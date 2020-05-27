Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A741E4994
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 18:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730443AbgE0QPf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 12:15:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21143 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728142AbgE0QPe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 12:15:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590596133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=szuzv9FjKVGOAkA2yRPWVoDFgWLJ5QQR49iMNPvrb04=;
        b=fxxHC6vYfwee1ibQG19WY1QzKTXYlmVd6v1Yyo95y4Mly0474Z11vlcOYET5W+Gejwqx0N
        HlyS98sZn8QSR865HR5O6YAVO5CQsgksAnHNS22wS2awer7ShC4qGbdPlXIuc27xrIJkIv
        bhqUsXtDBJPEOo1qLEdZcLNuKgqV9Mw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-3HrKDU-RONeM7F-0jM15gg-1; Wed, 27 May 2020 12:15:32 -0400
X-MC-Unique: 3HrKDU-RONeM7F-0jM15gg-1
Received: by mail-wm1-f69.google.com with SMTP id s15so979752wmc.8
        for <kvm@vger.kernel.org>; Wed, 27 May 2020 09:15:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=szuzv9FjKVGOAkA2yRPWVoDFgWLJ5QQR49iMNPvrb04=;
        b=tF3ctcD+8BA37OrVylyqxswAVnoaIMKz0zqYAQeT9H3bO+/+ZuIIsmDs1efr5OH7yU
         A/4FMm9vZhq1j84OHGYCiwAOQXM5vfEPb2xGkYreySzY/dSc0U+yIpahUuNwx6QYsTij
         gKtb78HFLVrJzyN21uSxcs1xRvNghwNHQf18VWwz85EKGs/IPJKf6uVSc+TBL8DpKHG6
         8KP6DNUKElh0en981Ph+4I4Z2FtmTTM7KJu3YYtGh9l2ZCglUaBg80aRXT1lPbArtRqX
         gaafGzJVCdc4V4g9OddpAoObID+vClZtE71JH5t91QLxbBlHf31FvGsHDxqwGx2y1GvP
         4hTw==
X-Gm-Message-State: AOAM533ILJ4tRSrKVe+sAwOcTz2cZVcp/WeXX6LYL2WtHSYLNv1GbHKj
        mVY6+v7nttHFg7DwRoe09K7+fmleSNEtV0upL6mjvIhU/xhQrnCdmENZUAMPcXo9YXylSirxFbb
        DAzw/xMX2eDt9
X-Received: by 2002:a5d:5492:: with SMTP id h18mr24900467wrv.330.1590596130881;
        Wed, 27 May 2020 09:15:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx54joe5BRQAwD5ipna0uYwbBkH1rExNY5+r8eX8vFQ8ZZvDbT4yU2cUwFnxyrJBdYC9V1OGQ==
X-Received: by 2002:a5d:5492:: with SMTP id h18mr24900437wrv.330.1590596130696;
        Wed, 27 May 2020 09:15:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id 5sm3130827wmz.16.2020.05.27.09.15.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 09:15:30 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Initialize tdp_level during vCPU creation
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+904752567107eefb728c@syzkaller.appspotmail.com
References: <20200527085400.23759-1-sean.j.christopherson@intel.com>
 <875zch66fy.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c444fbcc-8ac3-2431-4cdb-2a37b93b1fa2@redhat.com>
Date:   Wed, 27 May 2020 18:15:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <875zch66fy.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/05/20 12:03, Vitaly Kuznetsov wrote:
>>  
>>  	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
>> +	vcpu->arch.tdp_level = kvm_x86_ops.get_tdp_level(vcpu);
>>  
>>  	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> Looking at kvm_update_cpuid() I was thinking if it would make sense to
> duplicate the "/* Note, maxphyaddr must be updated before tdp_level. */"
> comment here (it seems to be a vmx-only thing btw), drop it from
> kvm_update_cpuid() or move cpuid_query_maxphyaddr() to get_tdp_level()
> but didn't come to a conclusive answer. 

Yeah, it makes sense to at least add the comment here too.

Paolo

