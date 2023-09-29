Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEC87B37E8
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 18:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbjI2Q2O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 12:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233054AbjI2Q2N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 12:28:13 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1822FBE
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 09:28:12 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c577fea3dcso146553865ad.2
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 09:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696004891; x=1696609691; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rfosLMRRH+Pv4UA4QxizdCsj+n9jFx9/vI46FHcTLFY=;
        b=4Sc2W8dMkcHwr8aAYPBtgjNMi3y/Owkfa1/HS1cKmFYl0Zk4H0p5pnn+WJvQOuxQ9o
         cvGOy3bLTmbEq138GFPsuNy6dQKqZjEAiUryo+CvGK7QA+0mOlRP2pHB9fclhCFkzGfh
         gSxkos4jXdGRemL+uYBHFfUWCX915lGEilh+8kB9tAjWlZ1t3RclRkPKeJwe4Ev2uJ/S
         aXpDlGO9Qvm8vM638S3z/gS6UQqLDUAARuJeZ6uOA/xDKOtdqJJD6eroZGeQSAd6Y8or
         6dQ3w5qMHrMvajsccmZs2zyT5HzOSK1oxmAXGCf6kOl2C+2hBo+UGinIVv17ircHPEws
         GoHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696004891; x=1696609691;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rfosLMRRH+Pv4UA4QxizdCsj+n9jFx9/vI46FHcTLFY=;
        b=idx23jqiJmGfzBJNcUYyF1uj++nhXKvLB3VwhJFtuTB4dBAymtGyTx0zO2qW1Bkqcb
         d8w5JXaZexVTbFu0D1L29krG30siLdMxIzTdogQtWUGjvrIS9sO1we1kiDMT3ZBVsIJT
         J+X4p2OXS76yFFDcn1gML8GXu71dId8Yd2ZVtsHolXvPjpb72UOkTemvAYRadcQl6e7l
         HV/mNfryJbsHVhwrCpTUs2TV4W4rqvEl4ZDNQDIZyXR/QhLDUZEbl+CIo78SsKvrSAbK
         iV0j46eQFlvanTZjPC0fhYPWaLXoszFTlX0TEHvu75AwqIlpZ9P2mChCeHOv79TFy3Ie
         Srpg==
X-Gm-Message-State: AOJu0YxCuKvi2xOaF4PbFHGdwxecKte2oW/c7yIF+lRviyYKK9KgjMhR
        GhlnC03OAuX7AA9vCthk21hbY60Eg5s=
X-Google-Smtp-Source: AGHT+IHpAEuMmgfGaZmmphet+NjiB00gjRzW9hIDx8ZXXhBpHFO/crqdz6+Deb3ACpPszohLiI38iZqpft0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:41c1:b0:1c6:1ad4:d1e6 with SMTP id
 u1-20020a17090341c100b001c61ad4d1e6mr75470ple.4.1696004891537; Fri, 29 Sep
 2023 09:28:11 -0700 (PDT)
Date:   Fri, 29 Sep 2023 09:28:09 -0700
In-Reply-To: <CALMp9eR++X5PCWGyVkZGxJoCnzTBUTs6f6yW=SzUXyejjUCgTQ@mail.gmail.com>
Mime-Version: 1.0
References: <20230928185128.824140-1-jmattson@google.com> <20230928185128.824140-3-jmattson@google.com>
 <ZRYgpnMJb1XYCeUs@google.com> <CALMp9eR++X5PCWGyVkZGxJoCnzTBUTs6f6yW=SzUXyejjUCgTQ@mail.gmail.com>
Message-ID: <ZRb7GTY_ALjviF_K@google.com>
Subject: Re: [PATCH v3 2/3] KVM: x86: Virtualize HWCR.TscFreqSel[bit 24]
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
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

On Fri, Sep 29, 2023, Jim Mattson wrote:
> On Thu, Sep 28, 2023 at 5:56=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > ---
> >  arch/x86/kvm/x86.c | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 791a644dd481..4dd64d359142 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3700,11 +3700,19 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, s=
truct msr_data *msr_info)
> >                 data &=3D ~(u64)0x100;    /* ignore ignne emulation ena=
ble */
> >                 data &=3D ~(u64)0x8;      /* ignore TLB cache disable *=
/
> >
> > -               /* Handle McStatusWrEn */
> > -               if (data & ~BIT_ULL(18)) {
> > +               /*
> > +                * Allow McStatusWrEn and TscFreqSel, some guests whine=
 if they
> > +                * aren't set.
> > +                */
>=20
> The whining is only about TscFreqSel. KVM actually supports the
> functionality of McStatusWrEn (i.e. allows the guest to write to the
> MCi_STATUS MSRs).

Ugh, I missed the usage can_set_mci_status().  Stupid open coded bit number=
s.

> How about...
>=20
> /*
> * Allow McStatusWrEn and TscFreqSel. (Linux guests from v3.2 through
> * at least v6.6 whine if TscFreqSel is clear, depending on F/M/S.
> */
>=20
> > +               if (data & ~(BIT_ULL(18) | BIT_ULL(24))) {
> >                         kvm_pr_unimpl_wrmsr(vcpu, msr, data);
> >                         return 1;
> >                 }
> > +
> > +               /* TscFreqSel is architecturally read-only, writes are =
ignored */
>=20
> This isn't true. TscFreqSel is not architectural at all.

Doh, right, the whole source of this mess is the uarch specific nature of t=
he MSR.

> On Family
> 10h, per https://www.amd.com/content/dam/amd/en/documents/archived-tech-d=
ocs/programmer-references/31116.pdf,
> it was R/W and powered on as 0. In Family 15h, one of the "changes
> relative to Family 10H Revision D processors," per
> https://www.amd.com/content/dam/amd/en/documents/archived-tech-docs/progr=
ammer-references/42301_15h_Mod_00h-0Fh_BKDG.pdf,
> was:
>=20
> =E2=80=A2 MSRC001_0015 [Hardware Configuration (HWCR)]:
>   =E2=80=A2 Dropped TscFreqSel; TSC can no longer be selected to run at N=
B P0-state.
>=20
> Despite the "Dropped" above, that same document later describes
> HWCR[bit 24] as follows:
>=20
> TscFreqSel: TSC frequency select. Read-only. Reset: 1. 1=3DThe TSC
> increments at the P0 frequency
>=20
> So, perhaps this block of code can just be dropped? Who really cares
> if the guest changes the value (unless it goes on to kexec a new
> kernel, which will whine about the bit being clear)?

Works for me.  If userspace wants to precisely emulate model specific behav=
ior,
then userspace can darn well intercept writes to the MSR.
