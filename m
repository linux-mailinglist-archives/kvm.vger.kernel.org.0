Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F52D6CF136
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 19:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjC2Reu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 13:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjC2Res (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 13:34:48 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08F240CF
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 10:34:47 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5417f156cb9so162795717b3.8
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 10:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680111287;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DNFNaG7IfQn0GoxGHQeAECVC0HUIZIm3W897ndNR614=;
        b=WVRjEOhFK42+QTaIBDpc5ESW5rIEkrLv8L7Of70FyuU+jDHA6odDZ7JUH5pB3A5Wou
         Rv7OTkRjntygAnYlh5u5jJl/eUE1cvTIVnf3EeFGrG7jVLYYRfnHYzsIQXBJZOZOfSWw
         PZV/qt4K4AEvkDd/RKzkQibmsAx4oR/6TiOFwhqjGInNwaHcq5zsLh3dZMiPEV8EkN5n
         QhARyxv083w07bSdn4SJVZD1hnjsyNEmiKXETlBZXytDlNICYaQxmKcG7arLGx6/hdDF
         l34UfVEHvDjYUhwwAd+4rjbOBGH43cTC//kaGTPj3aoxGkIFlJVudy1NfCARqPp7mZyD
         sSpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680111287;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DNFNaG7IfQn0GoxGHQeAECVC0HUIZIm3W897ndNR614=;
        b=21/skGr2LbTtvjNxXrwPGcZ7XiiQW3KtTOY5SJ2oRGbDLlGe/uRzhkluw9QdgfWRk7
         qU4dqXzc+/TyAzdilOrGyKxBk/qa1K3TuFXuTBAn0+Sw7Uern4JIIIoJ+S77fHg+9lh8
         X5s+PBxeDwhc+9V3jr4zWHYWyXMdC5nMmwtC5hvSdG8uUrxvpaKy8seUTOkgeQAgWMBB
         kB0ryqCJ399vPJT9ZAwuxgec7WZs1OkCdsrJW6WycJbXU2dDxlTIGvTWurL2GpwM0FZr
         1I28iAingsKt06UGlBqbAvBCkvkX6DbKvaxYZmjIZxMCOyNNIgG3qtwgk2hO03dKmdaw
         sk5A==
X-Gm-Message-State: AAQBX9extKesGJICxvEDHJpqsQNJwCiQCDRBppyhXw/bMHi+cjjjKOGe
        XW2XUgkxOhRipghwS1q8YkAqDhkX+aU=
X-Google-Smtp-Source: AKy350Y6YR29N0iDn73gQp4Y2NbtQaxpn3andjTdVc71mv2uApbarteg9hvLxcwa4AcT7C4hAeTsXmdcsv4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10c2:b0:b21:a3b8:45cd with SMTP id
 w2-20020a05690210c200b00b21a3b845cdmr13935709ybu.0.1680111287180; Wed, 29 Mar
 2023 10:34:47 -0700 (PDT)
Date:   Wed, 29 Mar 2023 10:34:45 -0700
In-Reply-To: <b9e9dd1c-2213-81c7-cd45-f5cf7b86610b@linux.intel.com>
Mime-Version: 1.0
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
 <20230319084927.29607-3-binbin.wu@linux.intel.com> <ZBhTa6QSGDp2ZkGU@gao-cwp>
 <ZBojJgTG/SNFS+3H@google.com> <12c4f1d3c99253f364f3945a998fdccb0ddf300f.camel@intel.com>
 <e0442b13-09f4-0985-3eb4-9b6a20d981fb@linux.intel.com> <682d01dec42ecdb80c9d3ffa2902dea3b1d576dd.camel@intel.com>
 <b9e9dd1c-2213-81c7-cd45-f5cf7b86610b@linux.intel.com>
Message-ID: <ZCR2PBx/4lj9X0vD@google.com>
Subject: Re: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit mode
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 29, 2023, Binbin Wu wrote:
>=20
> On 3/29/2023 10:04 AM, Huang, Kai wrote:
> > On Wed, 2023-03-29 at 09:27 +0800, Binbin Wu wrote:
> > > On 3/29/2023 7:33 AM, Huang, Kai wrote:
> > > > On Tue, 2023-03-21 at 14:35 -0700, Sean Christopherson wrote:
> > > > > On Mon, Mar 20, 2023, Chao Gao wrote:
> > > > > > On Sun, Mar 19, 2023 at 04:49:22PM +0800, Binbin Wu wrote:
> > > > > > > get_vmx_mem_address() and sgx_get_encls_gva() use is_long_mod=
e()
> > > > > > > to check 64-bit mode. Should use is_64_bit_mode() instead.
> > > > > > >=20
> > > > > > > Fixes: f9eb4af67c9d ("KVM: nVMX: VMX instructions: add checks=
 for #GP/#SS exceptions")
> > > > > > > Fixes: 70210c044b4e ("KVM: VMX: Add SGX ENCLS[ECREATE] handle=
r to enforce CPUID restrictions")
> > > > > > It is better to split this patch into two: one for nested and o=
ne for
> > > > > > SGX.
> > > > > >=20
> > > > > > It is possible that there is a kernel release which has just on=
e of
> > > > > > above two flawed commits, then this fix patch cannot be applied=
 cleanly
> > > > > > to the release.
> > > > > The nVMX code isn't buggy, VMX instructions #UD in compatibility =
mode, and except
> > > > > for VMCALL, that #UD has higher priority than VM-Exit interceptio=
n.  So I'd say
> > > > > just drop the nVMX side of things.
> > > > But it looks the old code doesn't unconditionally inject #UD when i=
n
> > > > compatibility mode?
> > > I think Sean means VMX instructions is not valid in compatibility mod=
e
> > > and it triggers #UD, which has higher priority than VM-Exit, by the
> > > processor in non-root mode.
> > >=20
> > > So if there is a VM-Exit due to VMX instruction , it is in 64-bit mod=
e
> > > for sure if it is in long mode.
> > Oh I see thanks.
> >=20
> > Then is it better to add some comment to explain, or add a WARN() if it=
's not in
> > 64-bit mode?
>=20
> I also prefer to add a comment if no objection.
>=20
> Seems I am not the only one who didn't get it=EF=BF=BD : )

I would rather have a code change than a comment, e.g.=20

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f63b28f46a71..0460ca219f96 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4931,7 +4931,8 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsign=
ed long exit_qualification,
        int  base_reg       =3D (vmx_instruction_info >> 23) & 0xf;
        bool base_is_valid  =3D !(vmx_instruction_info & (1u << 27));
=20
-       if (is_reg) {
+       if (is_reg ||
+           WARN_ON_ONCE(is_long_mode(vcpu) && !is_64_bit_mode(vcpu))) {
                kvm_queue_exception(vcpu, UD_VECTOR);
                return 1;
        }


The only downside is that querying is_64_bit_mode() could unnecessarily tri=
gger a
VMREAD to get the current CS.L bit, but a measurable performance regression=
s is
extremely unlikely because is_64_bit_mode() all but guaranteed to be called=
 in
these paths anyways (and KVM caches segment info), e.g. by kvm_register_rea=
d().

And then in a follow-up, we should also be able to do:

@@ -5402,7 +5403,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
        if (instr_info & BIT(10)) {
                kvm_register_write(vcpu, (((instr_info) >> 3) & 0xf), value=
);
        } else {
-               len =3D is_64_bit_mode(vcpu) ? 8 : 4;
+               len =3D is_long_mode(vcpu) ? 8 : 4;
                if (get_vmx_mem_address(vcpu, exit_qualification,
                                        instr_info, true, len, &gva))
                        return 1;
@@ -5476,7 +5477,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
        if (instr_info & BIT(10))
                value =3D kvm_register_read(vcpu, (((instr_info) >> 3) & 0x=
f));
        else {
-               len =3D is_64_bit_mode(vcpu) ? 8 : 4;
+               len =3D is_long_mode(vcpu) ? 8 : 4;
                if (get_vmx_mem_address(vcpu, exit_qualification,
                                        instr_info, false, len, &gva))
                        return 1;

