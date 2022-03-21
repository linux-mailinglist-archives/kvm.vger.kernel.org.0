Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9688A4E2ECE
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 18:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351681AbiCURKP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 13:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351677AbiCURKM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 13:10:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D0A462BF2
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 10:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647882523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dJfkHmVteh3T64TEzHnOxY0U7R9RqYwPmRB3l1CleQU=;
        b=DsjwguDXoeUrla7MDJh5Ni/NSgrao3jraCGbuaj2SLc4Jw2rCyb4A+9xTtSbfQValZ3dBT
        FpMooLsUnV3mSqprTJ0IaeIGDAG7ToX4dVkXfIJ1UvFDFqPReEmeFLRpzuaZcWYUXRrL7m
        T5z7YzoNjKtVLhx/5QGOOQoGqYkcNug=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-KlV3U4ByNeu6a6RUBmKeEg-1; Mon, 21 Mar 2022 13:08:42 -0400
X-MC-Unique: KlV3U4ByNeu6a6RUBmKeEg-1
Received: by mail-ed1-f69.google.com with SMTP id l24-20020a056402231800b00410f19a3103so9000446eda.5
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 10:08:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dJfkHmVteh3T64TEzHnOxY0U7R9RqYwPmRB3l1CleQU=;
        b=S1N5AWwqI+4whh7SCEwnqrRQqGzEBgyETqGqm84VuHuqb0xrg7HyvSOx3ncBiOAVwJ
         YtwWxkz2a5kebSxWZnbtsvyA22swdeROxK7GQ7eQpSLbeDM4+CYYb+18VaCFSrIrvu1P
         tGsDGMNnMPJBXha8MLXiWd4URUqAD2x2zij8XtS23UxXcOEumNU7R0qKZqi8vl76WNu6
         u5v3au30xtOxNss3ivBFskQ/nNQ+WGJadIMpoMWDGyZPrOwPjH/KYK+qv/0PUxYsBxwM
         wzFrK++vFsveQuoSZtMPMwghnXLAjegNqf+6Crq9Sno/mTsjkyWq0vLDCY2jtfBoQIp7
         FrZQ==
X-Gm-Message-State: AOAM5336x3hVDI0+WjKxZ0gFpZK+xr9ECjwmopEc7xu5FHn8GPrBKduz
        sOt77fEazJT8s/CrX0knA+O4PFI5zO9axG1s/7JeE4tiHi9Zk/UZkt2wk3s8liqXMAg4A+eRbn+
        mWV4ShqC/odVT
X-Received: by 2002:a17:906:ae0c:b0:6a6:a09f:f8d5 with SMTP id le12-20020a170906ae0c00b006a6a09ff8d5mr21214474ejb.627.1647882521152;
        Mon, 21 Mar 2022 10:08:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9vOllZzruoK6Px19KOGf8G+AZzG2Lh5NsWDQstKlL8pkmJxJy/bkjawSFGfb/CaNq0Q1wkQ==
X-Received: by 2002:a17:906:ae0c:b0:6a6:a09f:f8d5 with SMTP id le12-20020a170906ae0c00b006a6a09ff8d5mr21214429ejb.627.1647882520644;
        Mon, 21 Mar 2022 10:08:40 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id bd12-20020a056402206c00b00418c9bf71cbsm8003710edb.68.2022.03.21.10.08.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 10:08:39 -0700 (PDT)
Message-ID: <d94532b7-67bc-295b-fe40-73c519b6f916@redhat.com>
Date:   Mon, 21 Mar 2022 18:08:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Marc Orr <marcorr@google.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <20220321150214.1895231-1-pgonda@google.com>
 <f8500809-610e-ce44-9906-785b7ddc0911@redhat.com>
 <CAMkAt6pNE9MC7U_qQDwTrFG5e8qaiWZ6f0HzR+mk4dCNC2Ue8A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAMkAt6pNE9MC7U_qQDwTrFG5e8qaiWZ6f0HzR+mk4dCNC2Ue8A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/21/22 16:42, Peter Gonda wrote:
> On Mon, Mar 21, 2022 at 9:27 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 3/21/22 16:02, Peter Gonda wrote:
>>> SEV-ES guests can request termination using the GHCB's MSR protocol. See
>>> AMD's GHCB spec section '4.1.13 Termination Request'. Currently when a
>>> guest does this the userspace VMM sees an KVM_EXIT_UNKNOWN (-EVINAL)
>>> return code from KVM_RUN. By adding a KVM_EXIT_SHUTDOWN_ENTRY to kvm_run
>>> struct the userspace VMM can clearly see the guest has requested a SEV-ES
>>> termination including the termination reason code set and reason code.
>>>
>>> Signed-off-by: Peter Gonda <pgonda@google.com>
>>> Cc: Borislav Petkov <bp@alien8.de>
>>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>>> Cc: Brijesh Singh <brijesh.singh@amd.com>
>>> Cc: Joerg Roedel <jroedel@suse.de>
>>> Cc: Marc Orr <marcorr@google.com>
>>> Cc: Sean Christopherson <seanjc@google.com>
>>> Cc: kvm@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>
>> Looks good, but it has to also add a capability.
> 
> Thanks for the quick review! Just so I understand. I should add
> KVM_CAP_SEV_TERM or something, then if that has been enabled do the
> new functionality, else keep the old functionality?

No, much simpler; just something for which KVM_CHECK_EXTENSION returns 
1, so that userspace knows that there is a "shutdown" member to be 
filled by KVM_EXIT_SHUTDOWN.  e.g. KVM_CAP_EXIT_SHUTDOWN_REASON.

Paolo

