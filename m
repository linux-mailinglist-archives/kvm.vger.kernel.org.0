Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF907CC1B5
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 13:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbjJQLXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 07:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbjJQLXu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 07:23:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D0E9F
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 04:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697541779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JZIOMgVsnsQ5sKVZOqavpWhaECufWLCgd9frv4CfF0A=;
        b=G511lPTH6K0BwQ48gp7x3nt0HU9WbgQH3gxqFiTblnOH+gKwGHtmB169Xnn5P+/g6E5Yjb
        303CdsrlpHD57JGQrnpHyvn/fwDLf6Zq4/kOKJPvX88gSJ0YT1DVhrMf/741wEQziZKlEg
        QvLkmVkQprt1E+e0HTU5Ks61hPoQYjg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-299-X3YoemzfPly4lSLwUjN6dg-1; Tue, 17 Oct 2023 07:22:58 -0400
X-MC-Unique: X3YoemzfPly4lSLwUjN6dg-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9ae686dafedso406944766b.3
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 04:22:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697541777; x=1698146577;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JZIOMgVsnsQ5sKVZOqavpWhaECufWLCgd9frv4CfF0A=;
        b=lTnKoFMnjNyojG2bBHMJfXpIUsOIuDRBhezzaSvnM+1ehuUL9l28YKWYNCKCHhcceZ
         NzTkS+uLLu/YChkMpfk54mOPyuHBu1TT5LmegTIfaQMeJJ4TPsiBwkqn5xgatAcXiw9o
         LsE1f0NUNFVbxPqoQoyOH52+H4iZiZFr9VGjyNRMKBuIWCQ6S0iNP6N98edm55LTYG6c
         pDw630QJmitCuxqpxSI2NB5d8n+4o1SGBD1dO8KXPNsMlJn+OugNGAYqzbX7Rwd0lYzQ
         WodnlsnAPOlbzMqmArDRJfXnVIAD3KrleFLScUVGSfqK4Gy+RfBantE/mtptkmsqJr0A
         iHeA==
X-Gm-Message-State: AOJu0YyTPgJ0xEYmpB3+LJE5WCT5qq9LM2wBH7tP5b1ji6vYe6a9X8U3
        fhl+l0aD+B/V157T9yMj0cHVTWLmGVCXplrDEiFXutVGzFaJaQT6U6/VR5vbGVW2dk95wdtr3+d
        /Q2Y8XYmhULqK
X-Received: by 2002:a17:906:ef08:b0:9ba:65e:7529 with SMTP id f8-20020a170906ef0800b009ba065e7529mr1369391ejs.68.1697541777249;
        Tue, 17 Oct 2023 04:22:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOLUyvQoMWL9XFYq8RuPnMFLHZGBLDQoLys7Bbq0xQVsVm/PLnmF1v1E8g4wD+majZI5OU9g==
X-Received: by 2002:a17:906:ef08:b0:9ba:65e:7529 with SMTP id f8-20020a170906ef0800b009ba065e7529mr1369381ejs.68.1697541776968;
        Tue, 17 Oct 2023 04:22:56 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id o2-20020a170906358200b009a1dbf55665sm1053349ejb.161.2023.10.17.04.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 04:22:56 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Riccardo Mancini <mancio@amazon.com>
Cc:     bataloe@amazon.com, graf@amazon.de, kvm@vger.kernel.org,
        Greg Farrell <gffarre@amazon.com>
Subject: Re: [RFC PATCH 4.14] KVM: x86: Backport support for interrupt-based
 APF page-ready delivery in guest
In-Reply-To: <62e17c67-953d-469f-84cf-a998a15a8926@redhat.com>
References: <877co1cc5d.fsf@redhat.com>
 <20231013163640.14162-1-mancio@amazon.com> <87a5si8xcu.fsf@redhat.com>
 <62e17c67-953d-469f-84cf-a998a15a8926@redhat.com>
Date:   Tue, 17 Oct 2023 13:22:55 +0200
Message-ID: <87v8b57asw.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 10/16/23 16:18, Vitaly Kuznetsov wrote:
>> In case keeping legacy mechanism is a must, I would suggest you somehow 
>> record the fact that the guest has opted for interrupt-based delivery 
>> (e.g. set a global variable or use a static key) and short-circuit 
>> do_async_page_fault() to immediately return and not do anything in this 
>> case.
>
> I guess you mean "not do anything for KVM_PV_REASON_PAGE_READY in this 
> case"?

Yes, of course: KVM_PV_REASON_PAGE_NOT_PRESENT is always a #PF.

-- 
Vitaly

