Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A04515252
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 19:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379706AbiD2RgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 13:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358047AbiD2RgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 13:36:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C4331DA72
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 10:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651253570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aMQc2ckMqObOQomYmSJ0yLf2/h0LaCMh1bcFVp08uNo=;
        b=eDPKt5DWPm3ycClpV3YDXE00rhuST+ya+to4C8WhZxTpJX69/wt0UcKGb6DvoaX+6E31x4
        lbfdEc81N41VFAq/w0DuQX7L2qV4UfuFsNEX2DHwG0E1bY7tpXCm6awf6cooD7Rqr4owwO
        sNa8lJaghpeyOhr09gnrvQ/ISkzjFB4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-344-Veq3l_bpPVSIJYlPiaGsew-1; Fri, 29 Apr 2022 13:32:49 -0400
X-MC-Unique: Veq3l_bpPVSIJYlPiaGsew-1
Received: by mail-ed1-f70.google.com with SMTP id c23-20020a50d657000000b00425d5162a0dso4873749edj.16
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 10:32:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aMQc2ckMqObOQomYmSJ0yLf2/h0LaCMh1bcFVp08uNo=;
        b=WK8XNnz2CCmDGoE3bGQbG9HkbSa4c6u8D/pqq14vyOv6A/Xmdap5QZl8+ZPGXAkIV/
         09UODgdPjPKdmjluJPF0RuOB4FP2MlPOM9jXKm2dAxG6MKDqUvh76XP5MQ5S1hd4ogdS
         /+eydbWBvalhmYY4cG4eGYugBeWzj6fNl66ddxFu5doG3VnE5In4HusYsJZLBdKmIHLH
         Q+Vh8u6hadjDt+b+9BVnwEg0eo50RuzIc4DnTWvDITvEJdXDrOK1MyhoFT+usaFP2rrE
         2N9MM1j1LXjsw4Mk5LYWWGrk+PAnf1uB/1QsLt6wPb2ef30gzKj3d4t6HDqCS1qP1MoK
         MB+A==
X-Gm-Message-State: AOAM53133Q/9m0iz1ksBGm6y9J32ZlqJ0L/1o9AywahhLciPU993L+ZN
        XRJVJAYYv32D7HfB9EV1F7F4OD5ZvjxlvDziFYef0rKwQj+RNJzjScqrVDZfTcgFKvb7lcn1Vg8
        jJ+rEAog8mdap
X-Received: by 2002:a17:906:7311:b0:6f4:ba4:99ce with SMTP id di17-20020a170906731100b006f40ba499cemr362289ejc.177.1651253567221;
        Fri, 29 Apr 2022 10:32:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznANsbZuXDh3Y/MGOqkrWD0SD6cBUFfCrg1rtlU9lgYdrrGlRmEywSV+u85kusA68QY7rMxQ==
X-Received: by 2002:a17:906:7311:b0:6f4:ba4:99ce with SMTP id di17-20020a170906731100b006f40ba499cemr362275ejc.177.1651253567017;
        Fri, 29 Apr 2022 10:32:47 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id em20-20020a170907289400b006f3ef214e05sm828179ejc.107.2022.04.29.10.32.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 10:32:46 -0700 (PDT)
Message-ID: <d53df9d3-5de2-c1e6-11ce-a3b61e9e630e@redhat.com>
Date:   Fri, 29 Apr 2022 19:32:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3] KVM: SEV: Mark nested locking of vcpu->lock
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
Cc:     John Sperbeck <jsperbeck@google.com>,
        kvm list <kvm@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <20220407195908.633003-1-pgonda@google.com>
 <CAMkAt6r-Mc_YN-gVHuCpTj4E1EmcvyYpP9jhtHo5HRHnoNJAdA@mail.gmail.com>
 <CAMkAt6r+OMPWCbV_svUyGWa0qMzjj2UEG29G6P7jb6uH6yko2w@mail.gmail.com>
 <62e9ece1-5d71-f803-3f65-2755160cf1d1@redhat.com>
 <CAMkAt6q6YLBfo2RceduSXTafckEehawhD4K4hUEuB4ZNqe2kKg@mail.gmail.com>
 <4c0edc90-36a1-4f4c-1923-4b20e7bdbb4c@redhat.com>
 <CAMkAt6oL5qi7z-eh4z7z8WBhpc=Ow6WtcJA5bDi6-aGMnz135A@mail.gmail.com>
 <CAMkAt6rmDrZfN5DbNOTsKFV57PwEnK2zxgBTCbEPeE206+5v5w@mail.gmail.com>
 <0d282be4-d612-374d-84ba-067994321bab@redhat.com>
 <CAMkAt6ragq4OmnX+n628Yd5pn51qFv4qV20upGR6tTvyYw3U5A@mail.gmail.com>
 <8a2c5f8c-503c-b4f0-75e7-039533c9852d@redhat.com>
 <CAMkAt6qAW5zFyTAqX_Az2DT2J3KROPo4u-Ak1sC0J+UTUeFfXA@mail.gmail.com>
 <4afce434-ab25-66d6-76f4-3a987f64e88e@redhat.com>
 <CAMkAt6o8u9=H_kjr_xyRO05J=RDFUZRiTc_Bw-FFDKEUaiyp2Q@mail.gmail.com>
 <CABgObfa0ubOwNv2Vi9ziEjHXQMR_Sa6P-fwuXfPq76qy0N61kA@mail.gmail.com>
 <CAMkAt6pcg_Eg49nN5hS=wbeVWtPV1N_12G9Lvfgoq_bS_tUYog@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAMkAt6pcg_Eg49nN5hS=wbeVWtPV1N_12G9Lvfgoq_bS_tUYog@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 19:27, Peter Gonda wrote:
> Ah yes I missed that. I would suggest `role = SEV_NR_MIGRATION_ROLES`
> or something else instead of role++ to avoid leaking this
> implementation detail outside of the function signature / enum.

Sure.

Paolo

