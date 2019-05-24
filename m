Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 956C229C23
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 18:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390330AbfEXQ1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 12:27:13 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:46382 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389588AbfEXQ1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 12:27:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F71A80D;
        Fri, 24 May 2019 09:27:12 -0700 (PDT)
Received: from fuggles.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D91A83F575;
        Fri, 24 May 2019 09:27:11 -0700 (PDT)
Date:   Fri, 24 May 2019 17:27:07 +0100
From:   Will Deacon <will.deacon@arm.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool 2/2] run: Check for ghost socket file upon VM
 creation
Message-ID: <20190524162707.GA8993@fuggles.cambridge.arm.com>
References: <20190503170821.260705-1-andre.przywara@arm.com>
 <20190503170821.260705-3-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190503170821.260705-3-andre.przywara@arm.com>
User-Agent: Mutt/1.11.1+86 (6f28e57d73f2) ()
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 03, 2019 at 06:08:21PM +0100, Andre Przywara wrote:
> Kvmtool creates a (debug) UNIX socket file for each VM, using its
> (possibly auto-generated) name as the filename. There is a check using
> access(), which bails out with an error message if a socket with that
> name already exists.
> 
> Aside from this check being unnecessary, as the bind() call later would
> complain as well, this is also racy. But more annoyingly the bail out is
> not needed most of the time: an existing socket inode is most likely just
> an orphaned leftover from a previous kvmtool run, which just failed to
> remove that file, because of a crash, for instance.
> 
> Upon finding such a collision, let's first try to connect to that socket,
> to detect if there is still a kvmtool instance listening on the other
> end. If that fails, this socket will never come back to life, so we can
> safely clean it up and reuse the name for the new guest.
> However if the connect() succeeds, there is an actual live kvmtool
> instance using this name, so not proceeding is the only option.
> This should never happen with the (PID based) automatically generated
> names, though.
> 
> This avoids an annoying (and not helpful) error message and helps
> automated kvmtool runs to proceed in more cases.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  kvm-ipc.c | 30 ++++++++++++++++++++++++++----
>  1 file changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/kvm-ipc.c b/kvm-ipc.c
> index d9a07595..06909171 100644
> --- a/kvm-ipc.c
> +++ b/kvm-ipc.c
> @@ -43,10 +43,6 @@ static int kvm__create_socket(struct kvm *kvm)
>  
>  	snprintf(full_name, sizeof(full_name), "%s/%s%s",
>  		 kvm__get_dir(), kvm->cfg.guest_name, KVM_SOCK_SUFFIX);
> -	if (access(full_name, F_OK) == 0) {
> -		pr_err("Socket file %s already exist", full_name);
> -		return -EEXIST;
> -	}
>  
>  	s = socket(AF_UNIX, SOCK_STREAM, 0);
>  	if (s < 0) {
> @@ -58,6 +54,32 @@ static int kvm__create_socket(struct kvm *kvm)
>  	strlcpy(local.sun_path, full_name, sizeof(local.sun_path));
>  	len = strlen(local.sun_path) + sizeof(local.sun_family);
>  	r = bind(s, (struct sockaddr *)&local, len);
> +	/* Check for an existing socket file */
> +	if (r < 0 && errno == EADDRINUSE) {
> +		r = connect(s, (struct sockaddr *)&local, len);
> +		if (r == 0) {
> +			/*
> +			 * If we could connect, there is already a guest
> +			 * using this same name. This should not happen
> +			 * for PID derived names, but could happen for user
> +			 * provided guest names.
> +			 */
> +			pr_err("Guest socket file %s already exists.",
> +			       full_name);
> +			r = -EEXIST;
> +			goto fail;
> +		}
> +		if (errno == ECONNREFUSED) {
> +			/*
> +			 * This is a ghost socket file, with no-one listening
> +			 * on the other end. Since kvmtool will only bind
> +			 * above when creating a new guest, there is no
> +			 * danger in just removing the file and re-trying.
> +			 */
> +			unlink(full_name);

Can we print a diagnostic when this happens please? (hopefully the same
message as whatever you end up doing in the first patch).

Will
