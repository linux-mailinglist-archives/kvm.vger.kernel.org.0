Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47FDD5017E6
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 18:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244922AbiDNPvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 11:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352304AbiDNPkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 11:40:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EAE1BD95F1
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 08:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649949634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=64iwfqlvvcwkVV5nuqa1Iklmprqi6kfS6cUNegnWB6U=;
        b=XdMTgDPN7rnqVBWoAtOW+bhMRvE8fAv2wnoKMQcsivCz2LGSsI+PZTJlOngKbqiUJ4XjhG
        TPW4VpZDYmzBkcWzLZ7rCxJHHu/9It7VsvYvKi4qU8tJpzy45pxc6ICM25Iai6RPwlQ40Q
        Ea7sdaxhTyk0tyYTA6bgKR2PCD3q7Lk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10-JmKTSZnHOOyyAb9LsGupug-1; Thu, 14 Apr 2022 11:20:33 -0400
X-MC-Unique: JmKTSZnHOOyyAb9LsGupug-1
Received: by mail-wr1-f72.google.com with SMTP id z16-20020adff1d0000000b001ef7dc78b23so878441wro.12
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 08:20:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=64iwfqlvvcwkVV5nuqa1Iklmprqi6kfS6cUNegnWB6U=;
        b=VRDDcNNqZU9BtUBM74F6eZE9jbopsIgb2QhDuQEHAIb1NALitSDa4lxA9GQa7fpVZS
         0IXmN3EKuQQhqAjT5Hg81z8pK3FMFX25aUjQ0sP4m80cyZ1v2JfoE4fXolOQvdpZm/3P
         rKw5g6yUtvsuTdBXSsgwusRR+i7naISjjwEe8vg0LMm+OOA0I8YLS78XOZf2bgr+5cmV
         68NLYkoziOy/L6StmPqn4OSp+1vw0sut9ym9FjQ+0vbwx9BA/U5CbHTKgBbmyrV+4uN5
         /qEa8JzSUAJOSkulxy11Jyt49AydmA/kzLLYebO3slnw1UDvNlfUZER43Tjp0gXnG7Hi
         KtGQ==
X-Gm-Message-State: AOAM533EmJgupaNoNrY9BzcJK1Qghk1Mt81S5Si+dyy2/qVfjDRnkNu3
        +TFNDDyZgPMFKKeEKaLB0ADKLj5MqP2gYPJzqpz/xlmAyB600TdYYPtNjq+9eYdw0dXlm21+W0f
        J27KCsvGN9udJ
X-Received: by 2002:adf:f44d:0:b0:207:b33f:ea7b with SMTP id f13-20020adff44d000000b00207b33fea7bmr2460569wrp.628.1649949632203;
        Thu, 14 Apr 2022 08:20:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz28lZEMTJTb47EK9BNZSqS459NBUwBeb5BJhEgjG6VLFN5Y0XBH7mSIlwX3WKRvFNLHP3QEw==
X-Received: by 2002:adf:f44d:0:b0:207:b33f:ea7b with SMTP id f13-20020adff44d000000b00207b33fea7bmr2460559wrp.628.1649949632011;
        Thu, 14 Apr 2022 08:20:32 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id u1-20020a056000038100b00207a578e9d4sm2054623wrf.89.2022.04.14.08.20.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Apr 2022 08:20:31 -0700 (PDT)
Message-ID: <f4fa9962-a13f-dcc3-2ac3-e235545072cc@redhat.com>
Date:   Thu, 14 Apr 2022 17:20:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] kvm: selftests: Fix cut-off of addr_gva2gpa lookup
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Andrew Jones <drjones@redhat.com>
References: <20220414010703.72683-1-peterx@redhat.com>
 <Ylgn/Jw+FMIFqqc0@google.com> <Ylg4Nel3rDpHUzKT@xz-m1.local>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Ylg4Nel3rDpHUzKT@xz-m1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/14/22 17:05, Peter Xu wrote:
> 
> So sadly it's only gcc that's not working properly with the bitfields.. at
> least in my minimum test here.

Apparently both behaviors are allowed.

Paolo

