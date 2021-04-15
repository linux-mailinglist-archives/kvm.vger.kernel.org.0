Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A91360FDF
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 18:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbhDOQJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 12:09:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48178 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233673AbhDOQJh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Apr 2021 12:09:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618502953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W03gzn95lmQwBjXKVAhaFhaZhIzVrvHdOQqbqadkdVs=;
        b=Y6d2gYr72AOzGNBeHhFLHgPBIywi9Quh9haFfAQbxyxuuQypN1iK/MMhfpge4boT2ztAVR
        HC5srZAP5y661HY8KcI4hwVR/D0/nnNPDqdpU199lTctGDWEcsuBGKja8DW5sg/fwtA3+R
        ooH9Uq4vaM78hiq0eTLbTTXIJjOc/68=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-Bxzl9uvSPEaPqKCzLNyRsg-1; Thu, 15 Apr 2021 12:09:12 -0400
X-MC-Unique: Bxzl9uvSPEaPqKCzLNyRsg-1
Received: by mail-ed1-f72.google.com with SMTP id d2-20020aa7d6820000b0290384ee872881so1400420edr.10
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 09:09:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W03gzn95lmQwBjXKVAhaFhaZhIzVrvHdOQqbqadkdVs=;
        b=UK+sJkZ3p3/JIh8/WfnhAV5Q/tG+gDhT4itXg/gBYoQ80h6VSoMWcRkAMK8etl/E+M
         Vhf8ih3xEj+4DZG9aONelvHQe9o5AGsylzf8tyTgFy+4mgQKPdB4VT6z4+Fj9mfLEi94
         06VBWVBVWRaciDVAK2p46VqDQG1+V/FEPAWNHGPiWfkr6uBqOOGvNyVZMDBVfcsH53cA
         +MBcM+1B+B5RRXOgwW/xMkb5tDmH6zGh/3SeijhWaw9CndvkdM5jcnoY8za6Oc0DqlzJ
         FlrNapw2ZikRvFvm5XeGpSCfBcwGai5eXzub+4u8La8KnmYxbUrAOmkhsjYh8JPHY3sU
         JX3g==
X-Gm-Message-State: AOAM532ZkbqahgLvfrLMSdJ7BOh78+MeyMxcLsNCoqjQe6TCGPXeIxr0
        IymRBrDVTtT+LjlUTpZoyPwObapSqCEXmVaG+721+r3ZIQbgv7CKJzIi9wQRNO0HYu1BMjvGXOp
        CrCXWdn8kQLwB
X-Received: by 2002:a05:6402:441:: with SMTP id p1mr5124882edw.298.1618502951039;
        Thu, 15 Apr 2021 09:09:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzV22NsXbsmnW4eVxT5pHeM545ePFvzvr1Wdd3ttFnbZCyVMXKHBg1lLlAtWJY18Pa0LC02/Q==
X-Received: by 2002:a05:6402:441:: with SMTP id p1mr5124867edw.298.1618502950901;
        Thu, 15 Apr 2021 09:09:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id t15sm2297260edr.55.2021.04.15.09.09.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 09:09:10 -0700 (PDT)
Subject: Re: [PATCH v2 0/8] ccp: KVM: SVM: Use stack for SEV command buffers
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
References: <20210406224952.4177376-1-seanjc@google.com>
 <3d4ae355-1fc9-4333-643f-f163d32fbe17@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <88eef561-6fd8-a495-0d60-ff688070cc9e@redhat.com>
Date:   Thu, 15 Apr 2021 18:09:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <3d4ae355-1fc9-4333-643f-f163d32fbe17@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/04/21 20:00, Tom Lendacky wrote:
> For the series:
> 
> Acked-by: Tom Lendacky<thomas.lendacky@amd.com>

Shall I take this as a request (or permission, whatever :)) to merge it 
through the KVM tree?

Paolo

