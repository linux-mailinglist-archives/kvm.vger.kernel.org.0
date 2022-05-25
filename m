Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F089253425F
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 19:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245753AbiEYRq7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 13:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245760AbiEYRq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 13:46:57 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4510443EDE
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 10:46:56 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id r12-20020a056830448c00b0060aec7b7a54so10957152otv.5
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 10:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tsEdLKvObPS7G8Z2sQJhN9Qv1wSfra+nvCaaXzSR3NE=;
        b=TPnIR59MQ45wZoYaGmL9O8worQ137EbRsvzppbPyS1whsq0eOeIpSRl+fYbYGKYU8l
         X30g8eKP+oGDmMHHKGkodCqfuh3KmP3trn/mrXHSBGS9ytHpirPwoESMELyEwL7drh8i
         VD6AGeyGlDOZ2EKmkoTsu/UHywH1C8Ar9cV6oyPzecPth3ANRjY1/7pVeXISKns7zJv/
         BlEkvE6dcmUr5lEp491jGCQZeEZkpGQ7JMwJmr8W/L1F0+mtVzegIBrSov65CWaev1py
         YMI7xfBe0+JlXfSL+HVk3H0ZwkvQ1oWXgcK3aRJB2LxWd+N0IaE6Y6//JkENHMzUiP2v
         eRZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tsEdLKvObPS7G8Z2sQJhN9Qv1wSfra+nvCaaXzSR3NE=;
        b=IvHAMeC7xGU6GU86cODMQqEbkdwm9FsEpRF8Fww6p7LKyGfW6UajIi1k2Cth+8fAME
         YmrIwKWXn7eEK6iS+wZE0FWq3n/eXy54HUWS7jRcxodGuSCs4sMXz7kQfRuHhmOjU7nL
         wvfoe05MOFG2OXjgjDRPFa3yR0Gq3A96u57yPZl/hcrEBZi3KN064SD5FE7Uf78WnuAo
         oUHsRnZIglto+WO1aayX5x1ct8Q4I9BIhgKy27dxw2GKEvG7FelsLdBm5VhInr0oY1Q9
         D8ThFqZBzL0IgP8hGMNNH/Szw/lTITwdnDr2Kg/UtLf5gYxNjqZ+atOrZRZfa4MULASH
         DOzA==
X-Gm-Message-State: AOAM531jficQxNqYJASoK9qAQ9zyn6L9b5lKXSNKxm6Mrj5c2fDUbItp
        KBH5Oi78tKABVxwcu7S1PgVHSQQ1CC2sLZ+TMqTNaA==
X-Google-Smtp-Source: ABdhPJz4Y/uMvAYhmybXBKj+F5v37DNaWFYTJeREhWLMq2o9Zp3w+cBQ09c3LR8ST4KN+ehpHHfJiB+AO1m3nW7zoN0=
X-Received: by 2002:a05:6830:280e:b0:606:ae45:6110 with SMTP id
 w14-20020a056830280e00b00606ae456110mr12927454otu.14.1653500815319; Wed, 25
 May 2022 10:46:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220520204115.67580-1-jon@nutanix.com> <Yo5hmcdRvE1UrI4y@google.com>
 <3C8F5313-2830-46E3-A512-CFA4A24C24D7@nutanix.com>
In-Reply-To: <3C8F5313-2830-46E3-A512-CFA4A24C24D7@nutanix.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 25 May 2022 10:46:43 -0700
Message-ID: <CALMp9eT2=tEijnxUxFfv-1r5LJG4MyezqjnTsrysjuWGeko7_w@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: VMX: do not disable interception for
 MSR_IA32_SPEC_CTRL on eIBRS
To:     Jon Kohler <jon@nutanix.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 25, 2022 at 10:14 AM Jon Kohler <jon@nutanix.com> wrote:
>
>
>
> > On May 25, 2022, at 1:04 PM, Sean Christopherson <seanjc@google.com> wr=
ote:
> >
> > On Fri, May 20, 2022, Jon Kohler wrote:
> >> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >> index 610355b9ccce..1c725d17d984 100644
> >> --- a/arch/x86/kvm/vmx/vmx.c
> >> +++ b/arch/x86/kvm/vmx/vmx.c
> >> @@ -2057,20 +2057,32 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, =
struct msr_data *msr_info)
> >>                      return 1;
> >>
> >>              vmx->spec_ctrl =3D data;
> >> -            if (!data)
> >> +
> >> +            /*
> >> +             * Disable interception on the first non-zero write, unle=
ss the
> >> +             * guest is hosted on an eIBRS system and setting only
> >
> > The "unless guest is hosted on an eIBRS system" blurb is wrong and does=
n't match
>
> Ah right, thanks for catching that
>
> > the code.  Again, it's all about whether eIBRS is advertised to the gue=
st.  With
> > some other minor tweaking to wrangle the comment to 80 chars...
>
> RE 80 chars - quick question (and forgive the silly question here), but h=
ow are you
> counting that? I=E2=80=99ve got my editor cutting at 79 cols, where tab s=
ize is accounted
> for as 4 cols, so the longest line on my side for this patch is 72-73 or =
so.

Tab stops are every 8 characters. :-)
