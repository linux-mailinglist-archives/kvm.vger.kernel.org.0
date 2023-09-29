Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 737767B3913
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 19:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbjI2RnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 13:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233410AbjI2RnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 13:43:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C41019F
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 10:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696009340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mNuw9E3jfISKMJANhElE3yZ8P7q99O6Yz29XsBOWCUM=;
        b=caAofMvlr1cthonJcSGkYY7mGlUL37xVTeuviQwmbi6tmgs+55F+PzZ0qKbqtw1XvX1wSG
        fNdVUNK6yk57nJP7ZWzhdQOaOrD7QotULtZ/ixp4GtS+PkdvX6O6ODk7FNr1pU+Jx9ptYx
        34N5lLy2WYVwnWaD4Pny26po9H5wvrs=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-I1GaiHkYOpiLBPjAxW22dg-1; Fri, 29 Sep 2023 13:42:19 -0400
X-MC-Unique: I1GaiHkYOpiLBPjAxW22dg-1
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-4525176c993so8820104137.1
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 10:42:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696009338; x=1696614138;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mNuw9E3jfISKMJANhElE3yZ8P7q99O6Yz29XsBOWCUM=;
        b=jWHBWwQBvKeqK1nzp0aBQwudhtN3v6sm+6rWwNAAvDfQOvo5IpfH0u1U1VNKDYlus9
         liK52nyS97rEVHjf+HYTzRT+V7YcT+DgKUxP/t9HP7MObOQ5RQLGKssN36Hg7zAtKHM5
         HRIp3mUBfiXAVl7ttaX1yqahVY+9wgbKBvEzkSRHg4RajFqIhReMwmfnB8rs2IZKV4g9
         hY0m4DD7NHhJrrXmz6w2Ja/vnuY3ti/KA6J1Ihc5V2ciz+RB21p5Ae6c4PjGB96S0U4k
         x9vo2ttj+3udjImvjVAseX56sGKxf/uDhOAPM6bw/LthSaAKfzWlqDpfzGXVZASwmmfC
         8uug==
X-Gm-Message-State: AOJu0Yxr8HCRiSIBqPhT+CLK25wNzWFUB5Xoi30SPVTEKY7Q9TZzVl0/
        glQNb+5jBFXaCYnHG7hb5m0a/qn2i532GZzuTmjAoOL5YcqTFJpbl5Scf2pjowrQGapWtuMR89B
        IOV3d0SvwkQYVfH2THV2Em1MlbZJX5mu09j+I
X-Received: by 2002:a67:e210:0:b0:44d:5a92:ec43 with SMTP id g16-20020a67e210000000b0044d5a92ec43mr5037057vsa.24.1696009337903;
        Fri, 29 Sep 2023 10:42:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCp/AIdWPqEWbtC/9JPny903uCy02I1/BqXTOfQT6TzjBnF4NJ5GNkVAKN/E+OvugdC1agXXOcQyVdpUbSE60=
X-Received: by 2002:a67:e210:0:b0:44d:5a92:ec43 with SMTP id
 g16-20020a67e210000000b0044d5a92ec43mr5037044vsa.24.1696009337587; Fri, 29
 Sep 2023 10:42:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230928173354.217464-1-mlevitsk@redhat.com> <ZRYxvdmHpjxr3QKp@google.com>
In-Reply-To: <ZRYxvdmHpjxr3QKp@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 29 Sep 2023 19:42:05 +0200
Message-ID: <CABgObfYhtHS3d4m07+qAxPzdR_jZ4Q9OC9K=Tf4sviH1Nn5cyw@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] AVIC bugfixes and workarounds
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        iommu@lists.linux.dev, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Will Deacon <will@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 29, 2023 at 4:09=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Sep 28, 2023, Maxim Levitsky wrote:
> > Maxim Levitsky (4):
> >   x86: KVM: SVM: always update the x2avic msr interception
> >   x86: KVM: SVM: add support for Invalid IPI Vector interception
> >   x86: KVM: SVM: refresh AVIC inhibition in svm_leave_nested()
>
> Paolo, I assume you'll take the first three directly for 6.6?

Yes.

Paolo

> >   x86: KVM: SVM: workaround for AVIC's errata #1235
>

