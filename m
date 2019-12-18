Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A938B124225
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 09:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfLRIpu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 03:45:50 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42282 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725785AbfLRIpu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Dec 2019 03:45:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576658748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YmYBiPFyfuusGrvhq1tClIRmxYPrmjjmYU1jvZhdmKI=;
        b=DkYuk3/0t67PdqjfvLwOSYivN6o+EoOZN0mckKYkUFiKlP7O06DF87LMfyU+ZdVr3kG9kE
        RxpnyVjb1xZi1vI38nxPVRJLZ6aVznqCTKsBDMzehwO2Dy2hzTaHNNtTQheyopq35M9oYp
        c6SjvIg6FH+fSH11tnXmpIQA3jTxryE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-TzF1Y0flP6yYofZw8e2C2Q-1; Wed, 18 Dec 2019 03:45:47 -0500
X-MC-Unique: TzF1Y0flP6yYofZw8e2C2Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F8CF1005512;
        Wed, 18 Dec 2019 08:45:46 +0000 (UTC)
Received: from kamzik.brq.redhat.com (ovpn-117-182.ams2.redhat.com [10.36.117.182])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D1C051891F;
        Wed, 18 Dec 2019 08:45:41 +0000 (UTC)
Date:   Wed, 18 Dec 2019 09:45:38 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        vkuznets@redhat.com, maz@kernel.org
Subject: Re: [PATCH v2] tools/kvm_stat: Fix kvm_exit filter name
Message-ID: <20191218084538.qnnnla6rqcnoeeah@kamzik.brq.redhat.com>
References: <20191217020600.10268-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217020600.10268-1-gshan@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 17, 2019 at 01:06:00PM +1100, Gavin Shan wrote:
> The filter name is fixed to "exit_reason" for some kvm_exit events, no
> matter what architect we have. Actually, the filter name ("exit_reason")
> is only applicable to x86, meaning it's broken on other architects
> including aarch64.
> 
> This fixes the issue by providing various kvm_exit filter names, depending
> on architect we're on. Afterwards, the variable filter name is picked and
> applied by ioctl(fd, SET_FILTER).
> 
> Reported-by: Andrew Jones <drjones@redhat.com>

This wasn't reported by me - I was just the middleman. Credit should go
to Jeff Bastian <jbastian@redhat.com>

> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
> v2: Rename exit_field to exit_reason_field
>     Fix the name to esr_ec for aarch64
> ---
>  tools/kvm/kvm_stat/kvm_stat | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
> index ad1b9e646c49..4cf93110c259 100755
> --- a/tools/kvm/kvm_stat/kvm_stat
> +++ b/tools/kvm/kvm_stat/kvm_stat
> @@ -270,6 +270,7 @@ class ArchX86(Arch):
>      def __init__(self, exit_reasons):
>          self.sc_perf_evt_open = 298
>          self.ioctl_numbers = IOCTL_NUMBERS
> +        self.exit_reason_field = 'exit_reason'
>          self.exit_reasons = exit_reasons
>  
>      def debugfs_is_child(self, field):
> @@ -289,6 +290,7 @@ class ArchPPC(Arch):
>          # numbers depend on the wordsize.
>          char_ptr_size = ctypes.sizeof(ctypes.c_char_p)
>          self.ioctl_numbers['SET_FILTER'] = 0x80002406 | char_ptr_size << 16
> +        self.exit_reason_field = 'exit_nr'
>          self.exit_reasons = {}
>  
>      def debugfs_is_child(self, field):
> @@ -300,6 +302,7 @@ class ArchA64(Arch):
>      def __init__(self):
>          self.sc_perf_evt_open = 241
>          self.ioctl_numbers = IOCTL_NUMBERS
> +        self.exit_reason_field = 'esr_ec'
>          self.exit_reasons = AARCH64_EXIT_REASONS
>  
>      def debugfs_is_child(self, field):
> @@ -311,6 +314,7 @@ class ArchS390(Arch):
>      def __init__(self):
>          self.sc_perf_evt_open = 331
>          self.ioctl_numbers = IOCTL_NUMBERS
> +        self.exit_reason_field = None
>          self.exit_reasons = None
>  
>      def debugfs_is_child(self, field):
> @@ -541,8 +545,8 @@ class TracepointProvider(Provider):
>          """
>          filters = {}
>          filters['kvm_userspace_exit'] = ('reason', USERSPACE_EXIT_REASONS)
> -        if ARCH.exit_reasons:
> -            filters['kvm_exit'] = ('exit_reason', ARCH.exit_reasons)
> +        if ARCH.exit_reason_field and ARCH.exit_reasons:
> +            filters['kvm_exit'] = (ARCH.exit_reason_field, ARCH.exit_reasons)
>          return filters
>  
>      def _get_available_fields(self):
> -- 
> 2.23.0
>

Looks like a reasonable fix to me.

Reviewed-by: Andrew Jones <drjones@redhat.com>

