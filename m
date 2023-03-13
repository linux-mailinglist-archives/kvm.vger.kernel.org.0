Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58D6A6B7F4D
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 18:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbjCMRVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 13:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbjCMRVI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 13:21:08 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03397838B1
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 10:19:58 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 79-20020a630452000000b005030840e570so2816655pge.9
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 10:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678727932;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yDUeyLtnZmXQ74fhIlrEaM77YvYatD22GuV+U9jovtY=;
        b=D9UwxNmohnrcqApKroF2xG+1MiRU9/wkWfKyoClP/jeHdrwdFOewCO3gkrilfUMqnL
         0SlYeoi4oOo1tDeZSPNnShudTo4OmYg0qvvTKXAm4qvqFYRFXYPAEoJGgwCIES8admtk
         qdyU/JAAiIKPuHZ5kSdQw0QUKf+nbXFs5bXm3Iic7R7UliPMbxMED40pSDEF2WJpiHye
         Dvs4Z55or0XZd573NaVZYoy1K4cu1zCVOcCaIb2s8vSMHjC0FqcBVPJcf7CZ2iabjmYd
         iW5TFvYTCAru7Dgk14atangzC1v8C79IZGmN9jCxyHOE1LmeVS170dVp988H9NCKGnpl
         taXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678727932;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yDUeyLtnZmXQ74fhIlrEaM77YvYatD22GuV+U9jovtY=;
        b=4/R48T/FoyNmOecxAKdI604ptl73VWZ197VZ57XQFyi8z3/CTH4fbMmhmmyV5MOqXG
         p6hTKud4yGoKdiscBSaafIPeZy5MA8XSmkSHdtrO+E4eWRUSrMTnvsMou1NNI9DgRsPh
         KdI8wliRveyS6Chuhw8mi+ls5GSFAZhWCzz184lKFwS+D416xfOIeJZDyBseS9VpO0Pj
         KVAXkabGBz7vRKtB7+eHGsZmx8taI4Su2sDqdMPUAx1q1fNDxZimZzZCQooj6Tykprmu
         1dKX+JS84ix+oqWKXYjhccFjXYZ9rt/oRd6rXqYZssUvsOf55n3lMtowUyC8xTqvBWpX
         a6KQ==
X-Gm-Message-State: AO0yUKViWIsNS0ybWzITYFJqjX/mTD0cy3W52KLeCS0qRwnanvnR2phW
        zE9eGuXv+9M3mykwHMn+61dKH/nzjmA=
X-Google-Smtp-Source: AK7set+82XrQZ7jHIENlLFcGDRA9JFrTKocQQ/El0fbbVNnzJnKqR8rueoa0bqralqQh6sEL00jC8955CAw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:1d04:0:b0:623:8a88:1bba with SMTP id
 d4-20020a621d04000000b006238a881bbamr1952557pfd.2.1678727932223; Mon, 13 Mar
 2023 10:18:52 -0700 (PDT)
Date:   Mon, 13 Mar 2023 10:18:50 -0700
In-Reply-To: <ce2330db94b05605a0649a3da0595211c5bd71dd.camel@intel.com>
Mime-Version: 1.0
References: <20230310214232.806108-1-seanjc@google.com> <20230310214232.806108-6-seanjc@google.com>
 <ce2330db94b05605a0649a3da0595211c5bd71dd.camel@intel.com>
Message-ID: <ZA9avcHRPoIqZP/n@google.com>
Subject: Re: [PATCH v2 05/18] x86/reboot: KVM: Disable SVM during reboot via
 virt/KVM reboot callback
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chao Gao <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 13, 2023, Huang, Kai wrote:
> On Fri, 2023-03-10 at 13:42 -0800, Sean Christopherson wrote:
> > Use the virt callback to disable SVM (and set GIF=3D1) during an emerge=
ncy
> > instead of blindly attempting to disable SVM.=EF=BF=BD Like the VMX cas=
e, if KVM
> > (or an out-of-tree hypervisor) isn't loaded/active, SVM can't be in use=
.
> >=20
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
>=20
> [...]
>=20
> > -#if IS_ENABLED(CONFIG_KVM_INTEL)
> > +#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
> > =EF=BF=BD/* RCU-protected callback to disable virtualization prior to r=
eboot. */
> > =EF=BF=BDstatic cpu_emergency_virt_cb __rcu *cpu_emergency_virt_callbac=
k;
> > =EF=BF=BD
> > @@ -821,7 +821,7 @@ int crashing_cpu =3D -1;
> > =EF=BF=BD */
> > =EF=BF=BDvoid cpu_emergency_disable_virtualization(void)
> > =EF=BF=BD{
> > -#if IS_ENABLED(CONFIG_KVM_INTEL)
> > +#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
> > =EF=BF=BD	cpu_emergency_virt_cb *callback;
> > =EF=BF=BD
> > =EF=BF=BD	rcu_read_lock();
> > @@ -830,8 +830,6 @@ void cpu_emergency_disable_virtualization(void)
> > =EF=BF=BD		callback();
> > =EF=BF=BD	rcu_read_unlock();
> > =EF=BF=BD#endif
> > -	/* KVM_AMD doesn't yet utilize the common callback. */
> > -	cpu_emergency_svm_disable();
> > =EF=BF=BD}
>=20
> Shouldn't the callback be always present since you want to consider 'out-=
of-
> tree' hypervisor case?

No?  The kernel doesn't provide any guarantees for out-of-tree code.  I don=
't have
a super strong preference, though I do like the effective documentation the=
 checks
provide.  Buy more importantly, my understanding is that the x86 maintainer=
s want
to limit the exposure for these types of interfaces, e.g. `git grep IS_ENAB=
LED\(CONFIG_KVM`
for a variety of hooks that are enabled iff KVM is enabled in the kernel co=
nfig.
