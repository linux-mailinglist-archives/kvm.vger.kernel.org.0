Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881D5619546
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 12:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbiKDLTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 07:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiKDLS4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 07:18:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49504F70
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 04:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667560682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kHoAIk8gGgzmRz1JcrIvl9FQgofhIcHixcu/1kfBFxc=;
        b=BggHkxHrAtXsNdiGXLIXcL46BOvepfsD435aHVdjjTWDSJOA90iz5jYbjYJoqvpXBso+As
        s+HqyzMASy+h3flGXvgobq142Eqvo7lSbc+2cKL7tY9NlPyIzEjxHxX79JpQMKRBZFD26x
        YfIE92gFm20+89EMpcxh5hGKxfNSsWE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-225-gFiNr5QBOoecFG2ULK7OjQ-1; Fri, 04 Nov 2022 07:18:00 -0400
X-MC-Unique: gFiNr5QBOoecFG2ULK7OjQ-1
Received: by mail-ej1-f72.google.com with SMTP id gn34-20020a1709070d2200b0079330e196c8so3061400ejc.16
        for <kvm@vger.kernel.org>; Fri, 04 Nov 2022 04:18:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kHoAIk8gGgzmRz1JcrIvl9FQgofhIcHixcu/1kfBFxc=;
        b=OOT1V1jOy6fIQvHIq9hKvucwhtDVAyy34eeH7J+F8xOK4wgc1De9IiHWD6Y5pUO73h
         pcFpay7VBVK4oib73DnZYwvnI8FAUyZJ3M8ixjgCyLDu6NYHvfhbpJvGLjjkDKJSRhie
         /C8E5PH+CgEQ10sJxltuQKOnKrlmEh/3m4UTpnJGVKFvSDc904gnEnho6kS7LhGAghaR
         eRgJe2PWlW9N6b902UYPAS5YH/QN/B5W4aQ6FBXR633ueal90wPWAg1sEJLTfh1TEDon
         pUMYXEOzmqWOR0pktWiDU5wCVZ2RzoCA/tMugssu0XaTKfJJHE/xvviiRvCXLMvVgqGL
         cldQ==
X-Gm-Message-State: ACrzQf3E5psNEWRMkvPgtjEIohFuntQuDNsPSX0EWDq/nAK4n6cZE1v9
        DGOmBVBW2Y5a86q8/b8JBdw1xrlXOipuN0Tk7F697dYgFBBgi2OQKFamSf+MOElmRY+7gHMKrkh
        5A/HkHDpWL9UD
X-Received: by 2002:a05:6402:40d0:b0:462:7b99:d424 with SMTP id z16-20020a05640240d000b004627b99d424mr34881116edb.62.1667560679479;
        Fri, 04 Nov 2022 04:17:59 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM54T1gTDAQ5oXzrX4VqaDyc8Keny30jsNMG3T8qnTSOGUK8s5UAiCqaVhr3I9f+DqTpTZw34w==
X-Received: by 2002:a05:6402:40d0:b0:462:7b99:d424 with SMTP id z16-20020a05640240d000b004627b99d424mr34881091edb.62.1667560679280;
        Fri, 04 Nov 2022 04:17:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:4783:a68:c1ee:15c5? ([2001:b07:6468:f312:4783:a68:c1ee:15c5])
        by smtp.googlemail.com with ESMTPSA id sg43-20020a170907a42b00b0077d37a5d401sm1722787ejc.33.2022.11.04.04.17.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 04:17:58 -0700 (PDT)
Message-ID: <39a9b2a6-acc4-76fa-3134-46c5ec209a68@redhat.com>
Date:   Fri, 4 Nov 2022 12:17:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] tools/kvm_stat: fix attack vector with user controlled
 FUSE mounts
Content-Language: en-US
To:     Matthias Gerstner <matthias.gerstner@suse.de>
Cc:     kvm@vger.kernel.org
References: <20221103135927.13656-1-matthias.gerstner@suse.de>
 <f5315936-fbdf-c7b1-e7a9-f494001eebfd@redhat.com>
 <Y2T0khQR9DtEyuF4@kasco.suse.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y2T0khQR9DtEyuF4@kasco.suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/4/22 12:16, Matthias Gerstner wrote:
> 
> Sure I can come up with a patch. Should I send a new single patch
> containing both changes, a new patch series with two patches or do I
> need to send the afs change to a different mailing list? Sorry - I'm new
> to kernel development.

Yes, please send the AFS patch to linux-afs@lists.infradead.org.  In the 
meanwhile I will queue this patch as it is already an improvement.

Paolo

