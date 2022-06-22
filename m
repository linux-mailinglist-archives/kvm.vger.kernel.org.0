Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF8E553FF6
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 03:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355619AbiFVBSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 21:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347920AbiFVBSB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 21:18:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E534EF27
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 18:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655860678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wuuPsrvpildfWMsTFBzbFCeyycT4LB8kmzw//Wg2WxM=;
        b=jSd51UwGvncHsdhGX+pDJ52lhf22RyNaKa9oxoR76UegXr6pFsulKL/fq/z2Qx/Coz7Eze
        mMCsNia5G2/BeWg5I2Kwdjoy6UREWgEijprOBcY6KvFCh5mZdtbDPNu33z/JME4XPJvpUs
        AnqK6Q9ho8L0DSR9slLx+euFMYf/Q5w=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-251-EXlm4EeZM_yi1qqAPrwPTg-1; Tue, 21 Jun 2022 21:17:56 -0400
X-MC-Unique: EXlm4EeZM_yi1qqAPrwPTg-1
Received: by mail-lf1-f70.google.com with SMTP id c5-20020a056512238500b0047954b68297so7719852lfv.3
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 18:17:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wuuPsrvpildfWMsTFBzbFCeyycT4LB8kmzw//Wg2WxM=;
        b=FZ6Z5KCLmrGFcoKFAfmAuq4Qimaj/lAia/IvQJflMVJOedjajdade0tcshOprgT0rg
         o3dKvsnwBnUUA0QeTpeoyN9eE+FeBtZqv1xwqQtbSHHwdzG3wWRH+lCQGT3c6aT7BEBs
         A29x2yoQ2Gws7iwtBOuFwYOxhuxEiC/thTQHAzcpSwUl2nOhFIMonRYN6SkWOPz1whzY
         6aIIDg9M7Vl/Fwk659oWfWf0WfmbU725iGemUOBr8nZiPmzL3k4bPUwKKml47ZcUTvXD
         CvybNR7i8eecdv0RW1tLjFhNekigWYNGC8akTngadVCbkaHPC3tAU4if5pUieDWFytyx
         iNSQ==
X-Gm-Message-State: AJIora+Luyqq0C1WLgfJX29E+IqEeYeuijY5+m19O0A273XH9cDIbLSq
        GIwAPt2+UBQjNvQORBU49gWU8ea1/wVOb7DUJavovkbYcTkueT2p9QnczRZmqr1cN5Yuti7A0oK
        +GiWG5etmEqav7gsJCkoP05pvmVGt
X-Received: by 2002:a2e:8417:0:b0:25a:7fa7:fe5a with SMTP id z23-20020a2e8417000000b0025a7fa7fe5amr446419ljg.323.1655860675050;
        Tue, 21 Jun 2022 18:17:55 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tQNlmQ8fPIImazbU50qDI+J7JfZUZ94bHEMA0uqALx+tS95NtR1kJrk5qBRHT/YHfDAiJWdNBd86xhIi+W7kQ=
X-Received: by 2002:a2e:8417:0:b0:25a:7fa7:fe5a with SMTP id
 z23-20020a2e8417000000b0025a7fa7fe5amr446411ljg.323.1655860674845; Tue, 21
 Jun 2022 18:17:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220620024158.2505-1-jasowang@redhat.com> <87y1xq8jgw.fsf@redhat.com>
 <CACGkMEun6C9RgQVGq1B8BJMd9DyRQkSXj8shXVVhDymQYQLxgA@mail.gmail.com> <87sfny8hj8.fsf@redhat.com>
In-Reply-To: <87sfny8hj8.fsf@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 22 Jun 2022 09:17:37 +0800
Message-ID: <CACGkMEsg9791gQAtsz6fCM_=9_VmbqY=FehoTnpyiaJ7mCosDA@mail.gmail.com>
Subject: Re: [PATCH V2] virtio: disable notification hardening by default
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, mst <mst@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 21, 2022 at 5:58 PM Cornelia Huck <cohuck@redhat.com> wrote:
>
> On Tue, Jun 21 2022, Jason Wang <jasowang@redhat.com> wrote:
>
> > On Tue, Jun 21, 2022 at 5:16 PM Cornelia Huck <cohuck@redhat.com> wrote:
> >>
> >> The ifdeffery looks a big ugly, but I don't have a better idea.
> >
> > I guess you meant the ccw part, I leave the spinlock here in V1, but
> > Michael prefers to have that.
>
> Not doing the locking dance is good; I think the #ifdefs all over are a
> bit ugly, but as I said, I can't think of a good, less-ugly way...

Probably, but this is the way that is used by other subsystems. E.g
CONFIG_HARDEN_USERCOPY etc.

>
> > In the future, we may consider removing that, one possible way is to
> > have a per driver boolean for the hardening.
>
> As in "we've reviewed and tested this driver, so let's turn it on for
> every device bound to it"?

Right.

Thanks

>

