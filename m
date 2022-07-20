Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2E457B3E9
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 11:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236955AbiGTJbd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 05:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbiGTJbZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 05:31:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D08F5A2CD
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 02:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658309483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=44BQ4IyJ/Aqy9TbnKir1Ev2RlYMwItwK5RDWRIabjHU=;
        b=Lj5JZJJPTzesnNIVc0mmcstB0PTGXmMM9dSlX+ds8xWPpN+EuDYkqkeSoS2XCBRMdxRufa
        MLvc9HGiFuC1QX+cl/IYGl3ohRUB7jHy0yGw2DnwprIjTfojiEG5p69QlI1NJ3NtLvjFMx
        HXIKomTaz+jdFU0BPSaoTnEwWRAIl28=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-166-EgiD7QujOaO0L_2n90omTQ-1; Wed, 20 Jul 2022 05:31:22 -0400
X-MC-Unique: EgiD7QujOaO0L_2n90omTQ-1
Received: by mail-qv1-f72.google.com with SMTP id ns1-20020a056214380100b00474050cf13aso609267qvb.18
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 02:31:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=44BQ4IyJ/Aqy9TbnKir1Ev2RlYMwItwK5RDWRIabjHU=;
        b=2i6wVFXNwoGnS5ihSPatRS7zS5DLNn/u/5dEsVChSvJg337BosZVS/tkywEhbfdoUY
         1IxbVijx8QSwsx3N5QjyJGd8BEwXpxRptXIfOsVDUsjlUtKdGFOUndBU+rB/kQj1AC5A
         eMimjG46nHFR//o/pvMVCOMBMv7vV/A8A5a7HmQtY3aGIQ3pbC1SyQy5Iim25nAQ9FW2
         ktwyf22HJ+bpRE9ep+7OaNH8T1clL2ZnujaJ41p/J569vsNBTERXv0e0s0Fdy8ozDvkr
         c8+Xa2svAUYZ8Rm8f1xlidnpTwsEVVxxH00ib6EtCsU9eJmxjOPiHIFvh7xQqjyZyYF5
         2k8A==
X-Gm-Message-State: AJIora/8WIOSgeEKBQyGs4SgrFk5Kpjsm1eH2D1MTt10RXrK6r7ana/S
        menVXNjiRQeCV8HjHxUFdmns0sjqB+FoeTfR/c9ShpxR3MYk6Q09sRITzGC5+pQ57mvs+/07so4
        oJquJTnOuIvah
X-Received: by 2002:a05:6214:27ef:b0:473:2465:c2 with SMTP id jt15-20020a05621427ef00b00473246500c2mr28478303qvb.37.1658309480788;
        Wed, 20 Jul 2022 02:31:20 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v+B8X8QMtX2b/xtGFp+p1pM8hxjKbQxqsLoXR3e6M832KQzwNkM1/GT7Kxw2CYXadCDt72CA==
X-Received: by 2002:a05:6214:27ef:b0:473:2465:c2 with SMTP id jt15-20020a05621427ef00b00473246500c2mr28478298qvb.37.1658309480604;
        Wed, 20 Jul 2022 02:31:20 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id bl13-20020a05620a1a8d00b006b5f8f32a8fsm4887461qkb.114.2022.07.20.02.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 02:31:19 -0700 (PDT)
Message-ID: <63508f39e42738d145b3534e6768a9a09c9ca37e.camel@redhat.com>
Subject: Re: [PATCH 0/2] KVM: x86: never write to memory from
 kvm_vcpu_check_block
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com
Date:   Wed, 20 Jul 2022 12:31:17 +0300
In-Reply-To: <20220427173758.517087-1-pbonzini@redhat.com>
References: <20220427173758.517087-1-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-04-27 at 13:37 -0400, Paolo Bonzini wrote:
> Maxim reported the following backtrace:
> 
> [ 1355.807187]  kvm_vcpu_map+0x159/0x190 [kvm]
> [ 1355.807628]  nested_svm_vmexit+0x4c/0x7f0 [kvm_amd]
> [ 1355.808036]  ? kvm_vcpu_block+0x54/0xa0 [kvm]
> [ 1355.808450]  svm_check_nested_events+0x97/0x390 [kvm_amd]
> [ 1355.808920]  kvm_check_nested_events+0x1c/0x40 [kvm] 
> [ 1355.809396]  kvm_arch_vcpu_runnable+0x4e/0x190 [kvm]
> [ 1355.809892]  kvm_vcpu_check_block+0x4f/0x100 [kvm]
> [ 1355.811259]  kvm_vcpu_block+0x6b/0xa0 [kvm] 
> 
> due to kmap being called in non-sleepable (!TASK_RUNNING) context.
> Fix it by extending kvm_x86_ops->nested_ops.hv_timer_pending and
> getting rid of one annoying instance of kvm_check_nested_events.
> 
> Paolo
> 

Any update on this patch series? Pinging so it is not forgotten.

Best regards,
	Maxim Levitsky

