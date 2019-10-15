Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE90D786D
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 16:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732696AbfJOO1Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 10:27:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34642 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732211AbfJOO1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 10:27:24 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DE128C010931
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 14:27:23 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id 7so4975938wrl.2
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 07:27:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QdGQKq4j2J4HVHgLgc43dwZcILHDKYNfi5yiCbiqwN0=;
        b=OZDBwSrHGfcRwz4hjBETkPYUkOvtaG63Lud9NvdHz97ZKj93ZPjjPGft0p1rgXztbn
         YuRsr/wn5zMwkrWSm3JBfSM26pq9JprJ0ikHFpZdAFNsKKVhA9wAQ6Aw6pyJKNMLUbdm
         ZlDS8PG1nQ8fvUmcW2xRWnaYuvl7BYfcfRSEH/To6/SNxE8N9HKHo2/nY7A/Y52Yql9e
         hLAPIPrQaU1MRo2rTlnBSAIf8++HmD7uGRucwacm5iYgRxj7NHDsiX5NrBRQiYEd3+y9
         XfSsqUXLUQ+Lq8csq3NXSMNxkjnxYi913zWV3MUZskB3Wa1wtO2AJK1I5CNX7rFkYyf8
         woog==
X-Gm-Message-State: APjAAAWjnM/ZMq5oFM1A8Q5QJP/9+KM+BWRzA95/KaVMTDn5GsiKP9Lt
        uPDQUcQKvcxlOGy+kSZNLKTfuAzEatx176qGK5InIJHGgUaxtra79AmbBcav2exbE9/AVczS9lC
        bHCpdexOgYi+Y
X-Received: by 2002:adf:fa86:: with SMTP id h6mr30701794wrr.186.1571149642550;
        Tue, 15 Oct 2019 07:27:22 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyxR2drPlU+4UbM98K0Mkcvm4IK51SwQIPHgB8VmmCK6vK7rKqTG2D0ygR9QlSmvURfqJfnSQ==
X-Received: by 2002:adf:fa86:: with SMTP id h6mr30701773wrr.186.1571149642269;
        Tue, 15 Oct 2019 07:27:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d001:591b:c73b:6c41? ([2001:b07:6468:f312:d001:591b:c73b:6c41])
        by smtp.gmail.com with ESMTPSA id r7sm20483281wrt.28.2019.10.15.07.27.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2019 07:27:20 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Make fpu allocation a common function
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>
References: <20191014162247.61461-1-xiaoyao.li@intel.com>
 <87y2xn462e.fsf@vitty.brq.redhat.com>
 <20191014183723.GE22962@linux.intel.com>
 <87v9sq46vz.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <97255084-7b10-73a5-bfb4-fdc1d5cc0f6e@redhat.com>
Date:   Tue, 15 Oct 2019 16:27:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87v9sq46vz.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/19 12:53, Vitaly Kuznetsov wrote:
> A very theoretical question: why do we have 'struct vcpu' embedded in
> vcpu_vmx/vcpu_svm and not the other way around (e.g. in a union)? That
> would've allowed us to allocate memory in common code and then fill in
> vendor-specific details in .create_vcpu().

Probably "because it's always been like that" is the most accurate answer.

Paolo
