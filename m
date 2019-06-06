Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0B5637885
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 17:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbfFFPtt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 11:49:49 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52298 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729156AbfFFPtt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 11:49:49 -0400
Received: by mail-wm1-f67.google.com with SMTP id s3so453946wms.2
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 08:49:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fI31d08EoOe9UNN+MQeb1b63G1M+HPCyh8QpizfLh2o=;
        b=mkGzf6Wuj9/lRLBPrAnBenZp5fYC+IJY6kiX3aOgavctfHngb8TyxsB5q9uJT4iZG3
         yvnixwqDTQj0kleCuEH4Bg+Tu8x3IudP43fF0bEVFC77B/fd4vuLtt+tfBrV/KJoGMdN
         IEAFV4TOJbMMCtfaEF3rOGqFwHMhjgGpMKdY2QFNli5fiDme1zPN/zzzROjKFLHdhZqJ
         /i25zTbjpTTZJM8kr4RLdTRF6dDGDBgXOVBV9DwjHOijSpvHN3Ey30+ad/VNDhKacrrk
         hgnGJoKIQsSZWoSRh8VYwCalh/gMdrnqs0myuOvPu3yGud4q4tdM6WRtnyuOYevQSSJH
         P8RQ==
X-Gm-Message-State: APjAAAWkLm37p7ZHLxicgd7W3xyj4GdFBKqPyNI94GjfLkTij0JSauvk
        88gYbqedzeAIERZzu+a/7q0Hxg==
X-Google-Smtp-Source: APXvYqykCc0/VWyrLm+h982xooVTTZWfSPEavqLClMLAdn/l2ngjHk9hUnTDmCN73ugF5Yoe2xF8HQ==
X-Received: by 2002:a7b:c34b:: with SMTP id l11mr498076wmj.69.1559836186912;
        Thu, 06 Jun 2019 08:49:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id p16sm3093369wrg.49.2019.06.06.08.49.46
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 08:49:46 -0700 (PDT)
Subject: Re: [PATCH 05/15] KVM: nVMX: Don't rewrite GUEST_PML_INDEX during
 nested VM-Entry
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Liran Alon <liran.alon@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20190507160640.4812-1-sean.j.christopherson@intel.com>
 <20190507160640.4812-6-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <af9d1cbe-f571-4fe6-30fc-1462ea698d5a@redhat.com>
Date:   Thu, 6 Jun 2019 17:49:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190507160640.4812-6-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/19 18:06, Sean Christopherson wrote:
> -	if (enable_pml)
> +	/*
> +	 * Conceptually we want to copy the PML address and index from vmcs01
> +	 * here, and then back to vmcs01 on nested vmexit.  But since we always
> +	 * flush the log on each vmexit and never change the PML address (once
> +	 * set), both fields are effectively constant in vmcs02.
> +	 */
> +	if (enable_pml) {
>  		vmcs_write64(PML_ADDRESS, page_to_phys(vmx->pml_pg));
> +		vmcs_write16(GUEST_PML_INDEX, PML_ENTITY_NUM - 1);
> +	}

Yeah, it will be rewritten in vmx_flush_pml_buffer.

Just a little rephrasing of the comment:

+	 * The PML address never changes, so it is constant in vmcs02.
+	 * Conceptually we want to copy the PML index from vmcs01 here,
+	 * and then back to vmcs01 on nested vmexit.  But since we flush
+	 * the log and reset GUEST_PML_INDEX on each vmexit, the PML
+	 * index is also effectively constant in vmcs02.

Paolo
