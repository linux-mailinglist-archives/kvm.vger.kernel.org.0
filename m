Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D096276FDD9
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 11:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjHDJyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 05:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjHDJyB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 05:54:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558652118
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 02:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691142794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PkzZWuhLFjwMtxIV36yhw3pgLa/1WvhRgyDX/UaxUwM=;
        b=fp16RSBOFZCn1h1ZCQgOo3Pe4uZRRXveHewRmgJDfX1gJrZWocAvz7xdafK9Qz8FZbiWur
        VCQDCkizcbQ0H9fa3ETUK04q0M05bkdbuJcghcdRZURmpS3an/KPl5gbEyvWYuRtKdQNeP
        4eH2dQovwGluGoFPkic1zIkJAtHvEJ0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-o7_jsGoDPGy6g6g23TkJLg-1; Fri, 04 Aug 2023 05:53:12 -0400
X-MC-Unique: o7_jsGoDPGy6g6g23TkJLg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-99bcf56a2e9so131508266b.2
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 02:53:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691142791; x=1691747591;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PkzZWuhLFjwMtxIV36yhw3pgLa/1WvhRgyDX/UaxUwM=;
        b=TePlZjM7FrsoXIf3grAC4LOzLZjfHD+ICOQuAEpP6xUN1wlWuin6k0aOWISnNzZLWn
         EJ0RpwzdfznSCxgGttZl2rGhwQNAlCrw0OFtKrkO9C9uchIttEhBTx6FkhA+m1/tbxrf
         ZqYF5nd6b5P4ESOsR/9e+IRFsPnKiBu+i+spL8LnDfJB5GIq9BZ2pdfPIK30oCY2v4Fw
         M4t9BfaCJHs+sMpcNY5wvU0oQjRwruSa/BPo32YLk65jGMjHdFkNxN96slbDkTeSPDvB
         7hkDXUUbz+poZeI0fKFY3KyUJLxX+73ag4AzCiFjlBvZ+McqB9K+4/mqOvmZTqWFbiaL
         01LA==
X-Gm-Message-State: AOJu0Ywlsj5UZG+wp0cJPwC6IZf+kHo/dHgSjB/R9aSTEQec7ovqfBWH
        n3E8cbhj38xKkiFnZRiHvvr31jbKMzzWJ4w/td3m7KyR+CP4U1T9lcsVlZWwWV2HWKWmLSd66ff
        7x/HnIu3ur6rXQR/tGPtD
X-Received: by 2002:a17:906:300d:b0:99c:56d1:79fd with SMTP id 13-20020a170906300d00b0099c56d179fdmr1120806ejz.51.1691142790893;
        Fri, 04 Aug 2023 02:53:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEW5qWL5bsR84brLU2i7CNGBux5l/ftPiihWjKSS+UX++2jXU3WPyppKTdIa1dlgeFHQf8n0A==
X-Received: by 2002:a17:906:300d:b0:99c:56d1:79fd with SMTP id 13-20020a170906300d00b0099c56d179fdmr1120790ejz.51.1691142790580;
        Fri, 04 Aug 2023 02:53:10 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id x4-20020a170906804400b00992ed412c74sm1054137ejw.88.2023.08.04.02.53.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Aug 2023 02:53:09 -0700 (PDT)
Message-ID: <e578173b-8edf-dd89-494e-ecbec5b7cba8@redhat.com>
Date:   Fri, 4 Aug 2023 11:53:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 1/2] KVM: x86: Fix KVM_CAP_SYNC_REGS's sync_regs() TOCTOU
 issues
Content-Language: en-US
To:     Michal Luczaj <mhal@rbox.co>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, shuah@kernel.org
References: <20230728001606.2275586-1-mhal@rbox.co>
 <20230728001606.2275586-2-mhal@rbox.co> <ZMhIlj+nUAXeL91B@google.com>
 <7e24e0b1-d265-2ac0-d411-4d6f4f0c1383@rbox.co> <ZMqr/A1O4PPbKfFz@google.com>
 <38f69410-d794-6eae-387a-481417c6b323@rbox.co>
 <e55656be-2752-a317-80eb-ad40e474b62f@redhat.com>
 <8adb2f2b-df9c-3e49-3bdd-7970d918a1d0@rbox.co>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <8adb2f2b-df9c-3e49-3bdd-7970d918a1d0@rbox.co>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/3/23 23:15, Michal Luczaj wrote:
>>           *mmu_reset_needed |= kvm_read_cr0(vcpu) != sregs->cr0;
>>
>> with a call to the function just before __set_sregs_common returns.
> What about kvm_post_set_cr4() then? Should it be introduced to
> __set_sregs_common() as well?

Yes, indeed, but it starts getting a bit unwieldy.

If we decide not to particularly optimize KVM_SYNC_X86_SREGS, however, 
we can just chuck a KVM_REQ_TLB_FLUSH_GUEST request after __set_sregs 
and __set_sregs2 call kvm_mmu_reset_context().

Paolo

