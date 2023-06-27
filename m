Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25EF773FF11
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 16:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbjF0O4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 10:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbjF0Oz4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 10:55:56 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03402D54
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 07:55:23 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c337c5c56ecso559879276.3
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 07:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687877723; x=1690469723;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wm3T1w/U1n7ZEZqPNLWHLmqha4lRjJakqf6+Zvbx8hQ=;
        b=WsXwKNp7UA5NMzpN6h1XqnTEhXerrs3x0VG1Rm/ipON8tCFGGWL3kvMy450C0MhpJf
         +D1jaoR1NXq3aJNWvsAzuEogormLyeHP4MMO7OaEibI3PLRuo/BSeWdcjADvqr8ZlbLL
         P03uKTusfrt79Pi/yze694xMcVItpwCGDJQkziXo79NS6neswge5+cf8eFlFusooITCm
         8KbUx7572aJ83u635vp0PopV/JhkSul4eWSb32uTp7hgivi6eHee/vtQV3JDm26Hhyok
         djpUwrSdJQjLrUzijzyhzGNLtCQSuzlr4kN6Mvirpm1a04mZV3F2+p3NwI5r2vMLUDl+
         Q9Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687877723; x=1690469723;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wm3T1w/U1n7ZEZqPNLWHLmqha4lRjJakqf6+Zvbx8hQ=;
        b=STf+FrThtkU6ISWntHy7CW5mGTOEdd53ERe/x4xI+Rcl2yJv7nqzJrbYXWwXU/TKZW
         922b650QhTguMQMlMlsy5mZ6bfidMeKu7IkpoNe8n4fmvadYir7XaW9lui560TdwzXBj
         vBze7gIkAJmWGgVdWZYWcscMxeK3R/NTwSKFQcfWMsRzKVhQoNBMv6sg9S4XZ97MpcEC
         CZ9BxBa2nTorAo7DTM+8aL5gPkbpt9uoBeL+3lrbhX9z83wAYOvuHSAwqKyGoXDgD+tv
         qUHX7inEjkpEtx/9blzGbmyw2XpiqJuWA7gqSAstbaNHLKKMfbT8AnO56bKVxBF5MJ4t
         JHEw==
X-Gm-Message-State: AC+VfDwuycWcQ0aDYdWn5B5j53ncKEvGalKq7dS8npbwWa7gPNgOTeJm
        dKYuq+BmbBD9BttDOS6CbVajBxAMUHk=
X-Google-Smtp-Source: ACHHUZ6mRjHfXuC49K0RrjpD1bA61Pj0C/T57Ds0bmFPTcJgtEiO6VP6JL3nisUVd9xnjuf01KjJlFSPThE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:91:b0:ba8:6dc0:cacf with SMTP id
 h17-20020a056902009100b00ba86dc0cacfmr7539058ybs.12.1687877723132; Tue, 27
 Jun 2023 07:55:23 -0700 (PDT)
Date:   Tue, 27 Jun 2023 07:55:21 -0700
In-Reply-To: <44d59b64-716f-fa58-67ee-d66beb9132d2@intel.com>
Mime-Version: 1.0
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-14-weijiang.yang@intel.com> <ZJYwg3Lnq3nJZgQf@google.com>
 <9b12207f-7aec-7d46-9b7a-99355bc9d38d@intel.com> <ZJn/4qC35eFjfqJv@google.com>
 <44d59b64-716f-fa58-67ee-d66beb9132d2@intel.com>
Message-ID: <ZJr4WeeLuXYUvzYA@google.com>
Subject: Re: [PATCH v3 13/21] KVM:VMX: Emulate reads and writes to CET MSRs
From:   Sean Christopherson <seanjc@google.com>
To:     Weijiang Yang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023, Weijiang Yang wrote:
>=20
> On 6/27/2023 5:15 AM, Sean Christopherson wrote:
> > And the above is also wrong for host_initiated writes to SHSTK MSRs.  E=
.g. if KVM
> > is running on a CPU that has IBT but not SHSTK, then userspace can writ=
e to MSRs
> > that do not exist.
> >=20
> > Maybe this confusion is just a symptom of the series not providing prop=
er
> > Supervisor Shadow Stack support, but that's still a poor excuse for pos=
ting
> > broken code.
> >=20
> > I suspect you tried to get too fancy.  I don't see any reason to ever c=
are about
> > kvm_caps.supported_xss beyond emulating writes to XSS itself.  Just req=
uire that
> > both CET_USER and CET_KERNEL are supported in XSS to allow IBT or SHSTK=
, i.e. let
> > X86_FEATURE_IBT and X86_FEATURE_SHSTK speak for themselves.  That way, =
this can
> > simply be:
>=20
> You're right, kvm_cet_user_supported() is overused.
>=20
> Let me recap to see if I understand correctly:
>=20
> 1. Check both CET_USER and CET_KERNEL are supported in XSS before adverti=
se
> SHSTK is supported
>=20
> in KVM and expose it to guest, the reason is once SHSTK is exposed to gue=
st,
> KVM should support both modes to honor arch integrity.
>=20
> 2. Check CET_USER is supported before advertise IBT is supported in KVM=
=EF=BF=BD and
> expose IBT, the reason is, user IBT(MSR_U_CET) depends on CET_USER bit wh=
ile
> kernel IBT(MSR_S_CET) doesn't.

IBT can also used by the kernel...=20

Just require that both CET_USER and CET_KERNEL are supported to advertise I=
BT
or SHSTK.  I don't see why this is needs to be any more complex than that.

> > bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu, struct msr_data *=
msr)
> > {
> > 	if (is_shadow_stack_msr(...))
> > 		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> > 			return false;
> >=20
> > 		return msr->host_initiated ||
> > 		       guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
> > 	}
> >=20
> > 	if (!kvm_cpu_cap_has(X86_FEATURE_IBT) &&
> > 	    !kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> > 		return false;
>=20
> Move above checks to the beginning?

Why?  The is_shadow_stack_msr() would still have to recheck X86_FEATURE_SHS=
TK,
so hoisting the checks to the top would be doing unnecessary work.

> > 	return msr->host_initiated ||
> > 	       guest_cpuid_has(vcpu, X86_FEATURE_IBT) ||
> > 	       guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
> > }
