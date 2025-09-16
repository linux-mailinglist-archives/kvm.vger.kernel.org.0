Return-Path: <kvm+bounces-57731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CBD9B59A56
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:36:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99ECA188A612
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 14:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEA0E3375B3;
	Tue, 16 Sep 2025 14:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f7CUkQMx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D77918BBB9
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 14:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758032871; cv=none; b=kXUIalILRyq84VCM5mh/Aq3cjHq/XMUNVtMWLRhkJDE213+plJJBrSggHVMKut4tOfKdD/yHunL4S+xJQ3PaQr1c9nwq40VUweZ+feb8XlEWjYMhQwod02vtB/JOkeRRSv6q412D1Ff9MRq6Ry1G/61kLzrBP3im9WCbtxAsPO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758032871; c=relaxed/simple;
	bh=Bl3wTph0t/t38XfDavZGdmEBNaTLj90C6dzsXtMncyk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F0qks+syvakckJqPIZrn9RyeOiiVEJpdeOqETbnAN3faZ+5XPXFDE6olB1/RyrRXMdtKaazTc5vaE8aO0oDDmi8v4EmucB474QJhM4VSU9oOTyilmT70oi1lm3shg92GB+JPEWLFCNt/TTjZoYnH0gDO+dE6iyQi/kRzYHNnmpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f7CUkQMx; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2507ae2fa99so103343885ad.1
        for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 07:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758032870; x=1758637670; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rZg+b1gzt7W3Vp2tSwjZ1VAmX8NlLJ4esMJHe9St2zk=;
        b=f7CUkQMxupHih6RO5+pRYCJ+qfcC2JKIQlxmxxrLqmRinp7xyub/zi19JwXjKt6s0F
         k4+ENMRe9LjPLE4IogkqCbzLf+tLVbWoxJwKaTXoHJFo4gjCQavlXILm1YJhjp7NnVpV
         fVHOiR0nrE6DwlPeC/9q3qPASYXABraKNefByGro7G6eAolaE4mxpazW0bwsX6w9QJvM
         xZiZAUl6pdbIrolrCusnFbhcWUMp74YdW07hxVOQ6fPVwSTivPkmEiyC/IYZ9n7KgRFO
         j6WIxJHM5/eyHYeWm0XfZttPQW66P2aEq0At2U8W4NiDNaPmdml+0MDbll6/XLqyszno
         AJmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758032870; x=1758637670;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rZg+b1gzt7W3Vp2tSwjZ1VAmX8NlLJ4esMJHe9St2zk=;
        b=ctf1fdWcs4n6+HIUtHpp22fNyTepz7D+JpzVMRGF7/vG3madRFrujioXaGmYRN09sE
         UjHjb7ffbfehaKrRSlXhEOx1KL/nPeTjiIXg0T3gcZcFUrhHRSJJga1lvYLb73NQluEb
         77sH+rJ9jqewznYyn2qFvpAIhZDma0CadadUxNkH6KHnus4LYnvU5EwD/2JdlHgCUwhF
         NXDg7OVfBndZz6gzAkVLKcfaECpcm33LCkqo4teYwEdHG60JillXApLzOf5TB2aYylLz
         tHgA/8pdjhM6nbd45WzDgpEb/HClBYszlaLVepl88OKtT/+V06mKk4RNsQXskWYVXUVi
         hX3g==
X-Forwarded-Encrypted: i=1; AJvYcCW07Xb23yHpee17MO2rQe/tdXqKQp6sFfknUXtIlBdI4RbL0vSOThpyYRen17SebuEUwF4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJXlSb9wTepBFLwXvY+SJTOyRWGAHd+a93EpaHw/g14mj2NYrd
	oGM0wXxHkC11VuTel6Ki/YrezmwNkq5IBqzy3K7Xp79VaF6kr6Nn8OHL3NcmXVt23ML+z2kMu57
	4kKQ5zw==
X-Google-Smtp-Source: AGHT+IH78IXMBaTOlDIfM5c0hrpvW2eVE2rveQzn/coPgVcM6dVg/F5E8v4G7FAZuaIbsNUZzuBbUzZFkgc=
X-Received: from pjbsm2.prod.google.com ([2002:a17:90b:2e42:b0:32d:7097:81f1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ebc9:b0:24b:4a9a:703a
 with SMTP id d9443c01a7336-25d24da7536mr261650295ad.17.1758032869720; Tue, 16
 Sep 2025 07:27:49 -0700 (PDT)
Date: Tue, 16 Sep 2025 07:27:48 -0700
In-Reply-To: <p4gvfidvfrfpwy6p6cmua3pnm7efigjrbwipsoga7swpz3nmyl@t3ojdu4qx3w6>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1756993734.git.naveen@kernel.org> <46b11506a6cf566fd55d3427020c0efea13bfc6a.1756993734.git.naveen@kernel.org>
 <aMiY3nfsxlJb2TiD@google.com> <p4gvfidvfrfpwy6p6cmua3pnm7efigjrbwipsoga7swpz3nmyl@t3ojdu4qx3w6>
Message-ID: <aMlz5NTt_YA9foOc@google.com>
Subject: Re: [RFC PATCH v2 5/5] KVM: SVM: Enable AVIC by default from Zen 4
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Joao Martins <joao.m.martins@oracle.com>, 
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 16, 2025, Naveen N Rao wrote:
> On Mon, Sep 15, 2025 at 03:53:18PM -0700, Sean Christopherson wrote:
> > On Thu, Sep 04, 2025, Naveen N Rao (AMD) wrote:
> > > Users who specifically care about AVIC
> > 
> > Which we're trying to make "everyone" by enabling AVIC by default (even though
> > it's conditional).  The only thing that should care about the "auto" behavior is
> > the code that needs to resolve "auto", everything else should act as if "avic" is
> > a pure boolean.
> 
> This was again about preventing a warning in the default case since 
> there is nothing that the user can do here.

Yes, there is.  The user can disable SNP, either in firmware or in their kernel.

> I think this will trigger on most Zen 4 systems if SNP is enabled.

Which is working as intended.  Even if the user couldn't resolve the issue (by
disabling SNP), I would still want KVM to print a message.  My goal isn't to
provide a pristine kernel log, it's to provide a good experience for end users.

In my very strong opinion, for this case that means providing the user with as
much information as possible, at a loglevel that will alert them to an unexpected
and/or incompatible setup.

> By "users who specifically care about AVIC", I mean those users who want 
> to ensure it is enabled and have been loading kvm_amd with "avic=on". 
> For them, it is important to print a warning if there are missing 
> dependencies. For everyone else, I am not sure it is useful to print a 
> warning since there is nothing they can do.

As above, the user absolutely can resolve the SNP issue.

> > > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > > index 9fe1fd709458..6bd5079a01f1 100644
> > > --- a/arch/x86/kvm/svm/avic.c
> > > +++ b/arch/x86/kvm/svm/avic.c
> > > @@ -1095,8 +1095,13 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
> > >   */
> > >  void avic_hardware_setup(bool force_avic)
> > >  {
> > > +	bool default_avic = (avic == -1);
> > 
> > We should treat any negative value as "auto", otherwise I think the semantics get
> > a bit weird, e.g. -1 == auto, but -2 == on, which isn't very intuitive.
> 
> Agree. The reason I hard-coded the check to -1 is because 'avic' is 
> being exposed as a boolean and there is no way for a user to set it to a 
> negative value.

Gah, I misread param_set_bint().  That's a fortunate goof though, because looking
at this again, we can actually do better than accepting a magic value.  Similar
to nx_huge_pages, KVM can explicitly look for "auto" before parsing the value as
a boolean.  That way KVM's internal value for "auto" isn't user visible.

  #define AVIC_AUTO_MODE -1
  
  static int avic_param_set(const char *val, const struct kernel_param *kp)
  {
  	if (val && sysfs_streq(val, "auto")) {
  		*(int *)kp->arg = AVIC_AUTO_MODE;
  		return 0;
  	}
  
  	return param_set_bint(val, kp);
  }
  static const struct kernel_param_ops avic_ops = {
  	.flags = KERNEL_PARAM_OPS_FL_NOARG,
  	.set = avic_param_set,
  	.get = param_get_bool,
  };
  
  /*
   * Enable / disable AVIC.  In "auto" mode (default behavior), AVIC is enabled
   * for Zen4+ CPUs with x2AVIC (and all other criteria for enablement are met).
   */
  static int avic = AVIC_AUTO_MODE;
  module_param_cb(avic, &avic_ops, &avic, 0444);
  __MODULE_PARM_TYPE(avic, "bool");

