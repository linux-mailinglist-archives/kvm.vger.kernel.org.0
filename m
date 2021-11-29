Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D329F462514
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbhK2WfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:35:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbhK2We5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:34:57 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A23AC0D8C9F;
        Mon, 29 Nov 2021 09:55:23 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id y12so75379205eda.12;
        Mon, 29 Nov 2021 09:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Jo8G3WIFnCXJv/Wl58UbY8LXKhGKq56nydp8ornyGvw=;
        b=AjLExKPDvZxJIAf93isJIQG5owoNwi20rpmLOoVH2+s0ZWunJFmYMjECqAXAa31ExM
         qP4APhy58+cgNzSgs7CZp9bi9ZLfh1Um4f0T4CPKtFMqEQtoIPcbCG5ECCW+4/RpN3qP
         1k3CIsFPt6dBLkWzV5yOedKG0phAVvwwuaHgAci5hCbOZz8Yy6GMFp/NPR+R+K6sin3x
         5VGYrAKTVs66DntrIpjFBpn/bDtGwX2tdoIaZvud6hNaP1K0MD3EhI9p5XlWWUFTNrfc
         xT0cVpHPnGNOA0p342OPsO0F8T5HlLM3fktULYfIDujE1Zx4qHlH1POPSzpbzwUrncLW
         GVzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Jo8G3WIFnCXJv/Wl58UbY8LXKhGKq56nydp8ornyGvw=;
        b=Y3UxfDcyF0qmMRjjjgfWddyCmOiRu+ZT1p2bTtgeMAAJkOoiobR8rD9fohvAfJnxS1
         Bqec1RGf7kRxXc5TRZ7EJ760OaL8ihF4rOCauHkujCJoJOFICbA0RpeCnkZiMNe2oYaQ
         DJh1pbsxu+nIpeK4cJqokrJBpDuI4C7yCsEmhWonbfIKXFXI224eCUFnN+K2Acolclgl
         pbTDiuuGRui6c8p/zvDRJFTYLw9NPIgS2DMTO431tQIeEiYArjJGg1/EkTqmOMHabTtJ
         amdk25LoWunXBdQFGw+O9iyvhmYHWI22+t227+3KpP/EMbs5OO7s6qprELVMRcv4kwfu
         IZUg==
X-Gm-Message-State: AOAM530fct9t3JvZKws23sziAm7FyIez+WJYIOzco3ea/dOw5/XjniCr
        W4G0dlTNAWDx4c0PD2RFYS0=
X-Google-Smtp-Source: ABdhPJzV0Hp7Xr2kSqyy1FejCYUnhDh4xLCC02qQtKZ+cbHbGKkW71ueP1pw91X6C27D1KEW8+5Gvw==
X-Received: by 2002:a17:907:68e:: with SMTP id wn14mr62415481ejb.258.1638208522107;
        Mon, 29 Nov 2021 09:55:22 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id og38sm7559529ejc.5.2021.11.29.09.55.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 09:55:21 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <ba8341d6-7ee7-1af1-1385-0a9226bbf952@redhat.com>
Date:   Mon, 29 Nov 2021 18:55:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 11/43] KVM: Don't block+unblock when halt-polling is
 successful
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-12-seanjc@google.com>
 <cceb33be9e2a6ac504bb95a7b2b8cf5fe0b1ff26.camel@redhat.com>
 <4e883728e3e5201a94eb46b56315afca5e95ad9c.camel@redhat.com>
 <YaUNBfJh35WXMV0M@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YaUNBfJh35WXMV0M@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/29/21 18:25, Sean Christopherson wrote:
>> If I apply though only the patch series up to this patch, my fedora VM seems
>> to work fine, but my windows VM still locks up hard when I run 'LatencyTop'
>> in it, which doesn't happen without this patch.
> 
> Buy "run 'LatencyTop' in it", do you mean running something in the Windows guest?
> The only search results I can find for LatencyTop are Linux specific.

I think it's LatencyMon, https://www.resplendence.com/latencymon.

Paolo
