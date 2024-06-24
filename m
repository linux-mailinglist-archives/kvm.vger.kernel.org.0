Return-Path: <kvm+bounces-20403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EBF59914E23
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 15:15:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D1F11C2260B
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 13:15:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F1D513D628;
	Mon, 24 Jun 2024 13:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iWBjdUJd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B566713D610
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 13:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719234895; cv=none; b=NLDKuY+Zz5o8TsmRLog+2eYCTDuriAmgk8p68J1AILierG1bKWL9eaES3qA0P/2IqIqeSb99X9idmeJp15QRCLH/0uDjNAoMnPQ8eELJfWxEBLurJJ5DdFt+8aynnJDDO9eemWJc/Rx6nFoC1GJZ9Hs+jSHYFIcDMFvMNZN2luE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719234895; c=relaxed/simple;
	bh=+/6BQ2BG1bxJQoPmB7/6YWECUHPLZNKTSs2gL+HqZ5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n5M52GnSFF7MKdWIotHX6Id6GxMZvlMoP97ENPeq2kRw5NwBV4Y9orM6chowDwO0L9inpq+rLCOeVd1f57WGsqmd5ho61xC0OQ2QCiw5uyC/R9y9INI2GNRLWbEgNr1RyJeHGZZjIbMjWLKF1I4sWsYa7NYTqpjJquZYnhu30kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iWBjdUJd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719234892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=psoXTWsyRrOWGiZ3rF1af656XfNZf/PEqwEZrKB+trs=;
	b=iWBjdUJddzULr2JGKfNWas/NFwLLwiwtlTeG7XdVvmlo78ZXsz6izTtPxGjZ4Z1V2SGi2T
	YefDQPxvGCCJX4MfCpbRNrtVABRM78uzIo09Ldj0jU6BiirGNQSZVPbgcFuNFKGimwRs6X
	lgI2mBC8FKjUCmN/ecEA95Vyc/xpj5E=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-vH6truBYOVKxsVK5R-3KUQ-1; Mon, 24 Jun 2024 09:14:49 -0400
X-MC-Unique: vH6truBYOVKxsVK5R-3KUQ-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-52cdea74643so1717654e87.3
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 06:14:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719234887; x=1719839687;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=psoXTWsyRrOWGiZ3rF1af656XfNZf/PEqwEZrKB+trs=;
        b=xSrFI8FJDRbyYSY4pglg+71/iWzyPpu0lCPDB3ER9+fRT2C4UV/dDnsLWO9FF4CRd6
         ae3MedO3O+qrKPEwZlo+SJSF2wm0wkpvYq81DcFhfnIcwwOygi9uizdx2eQj5r8SUTyF
         WrG9QlTCyyPa1ASWfU9Ew+hqIYCkVlNrVl8T72BK/flfp/cIuG0cZip6I3C5M7uU6IDf
         gZBmIxdiu6fbPA6hJmn9rFedXs5Lijgi2mHFscURGe9BwDFhE9yhYynxGM3PHCHBlrJT
         L1xAj2EvoDQBIfMDmCzGCmlgaQnx3F+BW18mHWoyoqZ7YMwHRFKxKLPzgRc6cd5wBxHg
         0Gng==
X-Forwarded-Encrypted: i=1; AJvYcCUXdjolu0BMP1gXK3AL5K0NRPfNueBi2kpQvERqmxfUuw4M7pUs+JivByhSh+YoQt+oP3875Fs5BJdIJZZ3+/GSeDyF
X-Gm-Message-State: AOJu0YxnE1f5rA9SIw1ypFKrbOAbHazf5mcACMwc4XLXd1T+H8RKgo37
	Ri1p/BYjstafL9L6K6jQlXIncpG4nobQBSWWE6gQXLiX9BESurfn+0scbugi1h/hTZBCq4mzwxk
	hJVdlsAsICyvR4sf1WSCudsnFI6Op1TIaPyUBSMLAaI0EaZa+Iw==
X-Received: by 2002:a19:9115:0:b0:52c:df63:bebd with SMTP id 2adb3069b0e04-52ce0673528mr3081108e87.49.1719234887614;
        Mon, 24 Jun 2024 06:14:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEK6SFsYetZGUqeLgQLZvwhl1ZS0DQXPNrYO89UhypzC2WfyA0fXYNZTx19ynIFE/km2tg/Xg==
X-Received: by 2002:a19:9115:0:b0:52c:df63:bebd with SMTP id 2adb3069b0e04-52ce0673528mr3081072e87.49.1719234886822;
        Mon, 24 Jun 2024 06:14:46 -0700 (PDT)
Received: from redhat.com ([2.52.146.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42481910fd4sm133401405e9.30.2024.06.24.06.14.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jun 2024 06:14:46 -0700 (PDT)
Date: Mon, 24 Jun 2024 09:14:42 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Richard Henderson <richard.henderson@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, kvm@vger.kernel.org,
	Markus Armbruster <armbru@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] i386: revert defaults to 'legacy-vm-type=true' for
 SEV(-ES) guests
Message-ID: <20240624090345-mutt-send-email-mst@kernel.org>
References: <20240614103924.1420121-1-berrange@redhat.com>
 <20240624080458-mutt-send-email-mst@kernel.org>
 <Znlo4GMgJ91nKyft@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Znlo4GMgJ91nKyft@redhat.com>

On Mon, Jun 24, 2024 at 01:38:56PM +0100, Daniel P. Berrangé wrote:
> On Mon, Jun 24, 2024 at 08:27:01AM -0400, Michael S. Tsirkin wrote:
> > On Fri, Jun 14, 2024 at 11:39:24AM +0100, Daniel P. Berrangé wrote:
> > > The KVM_SEV_INIT2 ioctl was only introduced in Linux 6.10, which will
> > > only have been released for a bit over a month when QEMU 9.1 is
> > > released.
> > > 
> > > The SEV(-ES) support in QEMU has been present since 2.12 dating back
> > > to 2018. With this in mind, the overwhealming majority of users of
> > > SEV(-ES) are unlikely to be running Linux >= 6.10, any time in the
> > > forseeable future.
> > > 
> > > IOW, defaulting new QEMU to 'legacy-vm-type=false' means latest QEMU
> > > machine types will be broken out of the box for most SEV(-ES) users.
> > > Even if the kernel is new enough, it also affects the guest measurement,
> > > which means that their existing tools for validating measurements will
> > > also be broken by the new default.
> > > 
> > > This is not a sensible default choice at this point in time. Revert to
> > > the historical behaviour which is compatible with what most users are
> > > currently running.
> > > 
> > > This can be re-evaluated a few years down the line, though it is more
> > > likely that all attention will be on SEV-SNP by this time. Distro
> > > vendors may still choose to change this default downstream to align
> > > with their new major releases where they can guarantee the kernel
> > > will always provide the required functionality.
> > > 
> > > Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
> > 
> > This makes sense superficially, so
> > 
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > 
> > and I'll let kvm maintainers merge this.
> > 
> > However I wonder, wouldn't it be better to refactor this:
> > 
> >     if (x86_klass->kvm_type(X86_CONFIDENTIAL_GUEST(sev_common)) == KVM_X86_DEFAULT_VM) {
> >         cmd = sev_es_enabled() ? KVM_SEV_ES_INIT : KVM_SEV_INIT;
> >         
> >         ret = sev_ioctl(sev_common->sev_fd, cmd, NULL, &fw_error);
> >     } else {
> >         struct kvm_sev_init args = { 0 };
> >                 
> >         ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_INIT2, &args, &fw_error);
> >     }   
> > 
> > to something like:
> > 
> > if (x86_klass->kvm_type(X86_CONFIDENTIAL_GUEST(sev_common)) != KVM_X86_DEFAULT_VM) {
> >         struct kvm_sev_init args = { 0 };
> >                 
> >         ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_INIT2, &args, &fw_error);
> > 	if (ret && errno == ENOTTY) {
> > 		cmd = sev_es_enabled() ? KVM_SEV_ES_INIT : KVM_SEV_INIT;
> > 
> > 		ret = sev_ioctl(sev_common->sev_fd, cmd, NULL, &fw_error);
> > 	}
> > }
> > 
> > 
> > Yes I realize this means measurement will then depend on the host
> > but it seems nicer than failing guest start, no?
> 
> IMHO having an invariant measurement for a given guest configuration
> is a critical guarantee. We should not be allowing guest attestation
> to break as a side-effect of upgrading a software component, while
> keeping the guest config unchanged.

Well attenstation can change for a variety of reasons involving software
upgrades: host or guest. It is up to user to either trust both old and
new attestion, or pick one. Seems better than forcing policy host side.

> IOW, I'd view measurement as being "guest ABI", and versioned machine
> types are there to provide invariant guest ABI.

In practice we can't always do this exactly: e.g. vhost has
a rich feature mask and what we do is clear features not
supported by a specific host kernel.

Similarly for vhost-user where the ABI depends on an
external component.

So things can change if you move across host kernels.




> Personally, if we want simplicitly then just not using KVM_SEV_INIT2
> at all would be the easiest option. SEV/SEV-ES are legacy technology
> at this point, so we could be justified in leaving it unchanged and
> only focusing on SEV-SNP. Unless someone can say what the critical
> *must have* benefit of using KVM_SEV_INIT2 is ?


No objection.

> With regards,
> Daniel
> -- 
> |: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
> |: https://libvirt.org         -o-            https://fstop138.berrange.com :|
> |: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


