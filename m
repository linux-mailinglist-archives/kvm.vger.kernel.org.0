Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5BCB9273C
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 16:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfHSOnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 10:43:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48415 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbfHSOnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 10:43:31 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D750151EF1
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 14:43:30 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id u13so312482wmm.2
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 07:43:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vy5qJGgg/EWAtVC39C9kZNd1jY+63gY/oCqRox6uDxE=;
        b=cL+BtpZnUCeEJruFIwDyw0iHd7FZ/b0shxkAR4MLkiFlMz52K15H+uMF9V/hSWlJHg
         NnOmc0OmirbYlCMFUuxpVNNnXUPj6ofVqbdvy/XdyW44Ay0CzwZzxbyTg7mUOu2I3QxR
         sOfecPafUielDpULP/3iZFkD8X656SW0GHCuRXu6RmhpBO4EhYYk0St6o2K4oKR7ST00
         L/fBUtW90PX21eZAht+miwzp3xdHM83pbrPDasVkleO7nnUE6Mv7p+iVVeBCXvbgddtw
         MrtHsIKAiUN9AjENTjTxM3B/QtMs0V2puWsQo72Qgkgfy2b5h1gruAN0gAQNhN0xqLy9
         FRsg==
X-Gm-Message-State: APjAAAX1QjfrdHZqpy4iEe51mg9ekOziyw5J6xkX3tnx8LOxJ/c4J8Ur
        w5CSof0iapDwvkjZrL22HZRkOoim98yp2WdHCBIY+6LF0aArCp0O96CgtY0xgRklvq8wcn4ZphW
        KHGberhvIXkfN
X-Received: by 2002:adf:fc51:: with SMTP id e17mr27848057wrs.348.1566225809326;
        Mon, 19 Aug 2019 07:43:29 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxPD8E4pfzsD6lNAVTvslP3BefYn5k7Fw+gz99Gu/AIMAYkfS55sCrwFQGfa1MWklnzgdSsVw==
X-Received: by 2002:adf:fc51:: with SMTP id e17mr27848027wrs.348.1566225809018;
        Mon, 19 Aug 2019 07:43:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8033:56b6:f047:ba4f? ([2001:b07:6468:f312:8033:56b6:f047:ba4f])
        by smtp.gmail.com with ESMTPSA id s19sm16503316wrb.94.2019.08.19.07.43.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2019 07:43:28 -0700 (PDT)
Subject: Re: [PATCH RESEND v4 7/9] KVM: VMX: Handle SPP induced vmexit and
 page fault
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com
Cc:     mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        yu.c.zhang@intel.com, alazar@bitdefender.com
References: <20190814070403.6588-1-weijiang.yang@intel.com>
 <20190814070403.6588-8-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5f6ba406-17c4-a552-2352-2ff50569aac0@redhat.com>
Date:   Mon, 19 Aug 2019 16:43:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190814070403.6588-8-weijiang.yang@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/08/19 09:04, Yang Weijiang wrote:
> +			/*
> +			 * Record write protect fault caused by
> +			 * Sub-page Protection, let VMI decide
> +			 * the next step.
> +			 */
> +			if (spte & PT_SPP_MASK) {

Should this be "if (spte & PT_WRITABLE_MASK)" instead?  That is, if the
page is already writable, the fault must be an SPP fault.

Paolo

> +				fault_handled = true;
> +				vcpu->run->exit_reason = KVM_EXIT_SPP;
> +				vcpu->run->spp.addr = gva;
> +				kvm_skip_emulated_instruction(vcpu);
> +				break;
> +			}
> +
>  			new_spte |= PT_WRITABLE_MASK;

