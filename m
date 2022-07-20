Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC8A57C03E
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 00:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiGTWq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 18:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiGTWqz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 18:46:55 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C31321245
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 15:46:54 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id l9-20020a056830268900b006054381dd35so15263591otu.4
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 15:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=L6ONf5ncBROvqp8ldt4WaxSQOKhi80VGBXn7MyeukQM=;
        b=OF2F9CSZB9dqPMw9JeJAkZYBC49PxC8TCHuYSx0KzkiBwalvgpJt7XRlNs8Ce1K2lA
         brLh8Td3sWspE0ZXoaE/QAZ/dL96Bnm7Yw5hlK8PXufEhP57CWgFR0J4QQDFTIv4MChO
         JInIWUSV8uOGbxolJ/RtdequmVH84QVO66o4TDiRg/yw80ezxcdEwyrdHa6JPkJzfkzg
         EHAfQmenRDQqrPaEPwHoDGSb7inZTZLD99d04aivMxQq/AqHAYh7B5N0TkCNiXEtdKaY
         TxGhclRVTWvnJMe6N4jTEUV46ZFA2G9muTf8FH0YhZgt0W2LwRvNwxAtDv/DNiEdQsP8
         MW5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=L6ONf5ncBROvqp8ldt4WaxSQOKhi80VGBXn7MyeukQM=;
        b=cAnNX7zJKvSHuuYy+2MrH5fdZ278Y9WwFxAM9D+Vbn/lKZOPb981nL5b4SMsXOqaao
         dNpXemcfktv2V28zCL5Sj+7npwWmqMX/dJRxOmxzfDmBRQsbey+kefredGLhMSfm9cTn
         +PbqCHgmzlKkoUKRrDp3L0wANgn2VFiLaN/zFEubRTnD/3XNQ4JNq9TcNAtI941sQu/u
         2tbQZgTGyrLAC1g8lGFuK4DNgmMdu8JIbHBCvU3SQp42YRnNmDnHses69KVpkItIAguZ
         r5VB7PDE84vXamS4twaJYCLaZW63GfWQhsuna23E5i09FY4OVJpEb1akWQL5jNPIousM
         cIAA==
X-Gm-Message-State: AJIora/N2Jc4V/5Hz30gZEk5SMlGhOkLSkrzvaYSP851mgMLlj5KDr+A
        zZohGy7SHN/GS1f7n4TaGkfMlpx5LI4QzCGecRlT7A==
X-Google-Smtp-Source: AGRyM1uPF6DlqAUTYGw9rwWhLZe0IbZS8bttwlHpwkLIdngm1dXnNU/Q4NNnFl79sj+FOUsPicgVXN4MCKX0nyDM0UA=
X-Received: by 2002:a9d:38e:0:b0:61c:7323:6202 with SMTP id
 f14-20020a9d038e000000b0061c73236202mr14777740otf.267.1658357213389; Wed, 20
 Jul 2022 15:46:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220709134230.2397-1-santosh.shukla@amd.com> <20220709134230.2397-6-santosh.shukla@amd.com>
 <Yth2eik6usFvC4vW@google.com>
In-Reply-To: <Yth2eik6usFvC4vW@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 20 Jul 2022 15:46:42 -0700
Message-ID: <CALMp9eQ_ygX7P-YKGQh0mZein6LcTM=gMbQpi8HNfm7XaFi36w@mail.gmail.com>
Subject: Re: [PATCHv2 5/7] KVM: SVM: Add VNMI support in inject_nmi
To:     Sean Christopherson <seanjc@google.com>
Cc:     Santosh Shukla <santosh.shukla@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 20, 2022 at 2:41 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Sat, Jul 09, 2022, Santosh Shukla wrote:
> > Inject the NMI by setting V_NMI in the VMCB interrupt control. processor
> > will clear V_NMI to acknowledge processing has started and will keep the
> > V_NMI_MASK set until the processor is done with processing the NMI event.
> >
> > Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> > ---
> > v2:
> > - Added WARN_ON check for vnmi pending.
> > - use `get_vnmi_vmcb` to get correct vmcb so to inject vnmi.
> >
> >  arch/x86/kvm/svm/svm.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 44c1f2317b45..c73a1809a7c7 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -3375,12 +3375,20 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
> >  static void svm_inject_nmi(struct kvm_vcpu *vcpu)
> >  {
> >       struct vcpu_svm *svm = to_svm(vcpu);
> > +     struct vmcb *vmcb = NULL;
> > +
> > +     ++vcpu->stat.nmi_injections;
> > +     if (is_vnmi_enabled(svm)) {
> > +             vmcb = get_vnmi_vmcb(svm);
> > +             WARN_ON(vmcb->control.int_ctl & V_NMI_PENDING);
>
> Haven't read the spec, but based on the changelog I assume the flag doesn't get
> cleared until the NMI is fully delivered.

Ooh! Is there a spec to read now?!?
