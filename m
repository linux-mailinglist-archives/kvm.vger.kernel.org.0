Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B974EE146
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 21:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238357AbiCaTFB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 15:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238342AbiCaTE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 15:04:59 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B0D236B94
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 12:03:07 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-df02f7e2c9so247519fac.10
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 12:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Y9OIJANf76jzSJd9L5U+SzdUkIWV209AsBiBncnFScM=;
        b=bEm2yuouS6lAbTFovB1/4RrT/3TELh94+lGLsI7iIZya40yLYD9v4Xas9gvyZDTn4l
         sxm70vmI6quI4851mMs19avfnsaFNDcKtemMpGltwPVDKtFTEv+Loeq2JPqXZDnK4rJ4
         uBiXM/bWRAP+knQODGECBjwj21pWHi//DvO+tBZ7475eOAohpg0Rj7KkNLkdp58zgWU7
         j63kTul0bnqG/ekMF3dSb70MPdCxGZQ4YX6IBziJWdo4+Tu9/G4m5qbRf07LkG2E8hPP
         vs4SX4BHHYbgESrS/pqe7GlrMrQ49IdxqQjMc5am7RAXfI+zz32WxchSVKfP4m0s2v4x
         X4Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Y9OIJANf76jzSJd9L5U+SzdUkIWV209AsBiBncnFScM=;
        b=RVKBZ0bF2xW0arC+23uIf2hm4TmIdRI15tgdh2FVrGKRTxUTql1LyNhCneH4VBB9Y2
         GRIKf3xUWBrbYfutIhWYCe86qcQKY0AzcsY+8Zvn3QNP7AYYM6cUad9Ox80o5mnM6/KG
         O19AD1rZtH3ji7hJUhb1LWUWrCAryvqBUJ593eCa9rpGplO2Hqf9U5f0+fQzSmDPVYiu
         5G9LZB4GZEp+FPOIIfofweJIgvmnt3cs2fyrcnxm9JZ9wWWpNXgvwkOG+y2uFRwn0aCL
         wkaUtloQ1uY9Kds20FLHTs5i6OYnJiGZYC9I10AAENtpLxI6Sb0/2DTy0Y2LMC+WWS4D
         B0mw==
X-Gm-Message-State: AOAM531gwg06mJjLb9/E5R0egaU6m5iNNiLL2HdtW88RmY0wNKbsAmKH
        xAZ98hMB80JaKQHgNgSXNFa6KaDKP0XBNDbOKvjW3bigvf0=
X-Google-Smtp-Source: ABdhPJyGnGEaf9vPHzC+MobA92MFEd9DX+BLAbDZRzbUl/QGzOYdQRy/qXT70WuZkmxE6zAsKj26I0LTpgZepkxm6LY=
X-Received: by 2002:a05:6870:e611:b0:dd:f6e5:7871 with SMTP id
 q17-20020a056870e61100b000ddf6e57871mr3400074oag.218.1648753387168; Thu, 31
 Mar 2022 12:03:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220330182821.2633150-1-pgonda@google.com> <YkXgq7hez9gGcmKt@google.com>
 <CAA03e5EcApE8ZnHEwZdZ3ecxYvh1G3nF-YDU5mhZa-15QZ0tew@mail.gmail.com>
 <CAA03e5Ghw6rJ82GhGKW+sCDgDRpZPLmhq29Wgmd0H40nvbX+Rg@mail.gmail.com>
 <CAMkAt6qr7zwy2uG1EaoZyvXnXMZ7Ho-CxQvRpcuUCx8wiA+6UQ@mail.gmail.com>
 <YkX46P6mn+BYWsv2@google.com> <CAMkAt6oiXaDfzRWo0GDNGyFeA2f8DPmWGsJvpFpB1+A8XSz4rA@mail.gmail.com>
In-Reply-To: <CAMkAt6oiXaDfzRWo0GDNGyFeA2f8DPmWGsJvpFpB1+A8XSz4rA@mail.gmail.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 31 Mar 2022 12:02:56 -0700
Message-ID: <CAA03e5F3MYKGMsHKbdsbQ-x5w3LMs7hpCB-tyfOTzDf29DQ76Q@mail.gmail.com>
Subject: Re: [PATCH v3] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
To:     Peter Gonda <pgonda@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > > > The reason code set is meant to provide hypervisors with their ow=
n
> > > > > termination SEV-ES Guest-Hypervisor Communication Block
> > > > > Standardization reason codes. This document defines and owns reas=
on
> > > > > code set 0x0 and the following reason codes (GHCBData[23:16]):
> > > > > 0x00 =E2=80=93 General termination request
> > > > > 0x01 =E2=80=93 SEV-ES / GHCB Protocol range is not supported.
> > > > > 0x02 =E2=80=93 SEV-SNP features not supported
> > > >
> > > > Reading this again, I now see that "reason_set" sounds like "The
> > > > reason code is set". I bet that's how Sean read it during his revie=
w.
> > > > So yeah, this needs comments :-)!
> > >
> > > I'll add comments but I agree with Marc. These are part of the GHCB
> > > spec so for the very specific SEV-ES termination reason we should
> > > include all the data the spec allows. Sounds OK?
> >
> > Ugh, so "set" means "set of reason codes"?  That's heinous naming.  I d=
on't have a
> > strong objection to splitting, but at the same time, why not punt it to=
 userspace?
> > Userspace is obviously going to have to understand what the hell "set" =
means
> > anyways...
>
> I am fine just copying the entire MSR to userspace.

I'm fine with it too. Thanks for the feedback, Sean!
