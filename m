Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451122B4EE5
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730795AbgKPSJz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:09:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40980 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730379AbgKPSJy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 13:09:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605550193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GIFV53zQFLU+Cuk+mK8udHxZ0BakVben5sR1NOOPdzU=;
        b=M0CnI/3y149HQlviziFq2RqiIPrx+sJKiBUB5kn9aUBDdgtr7O7SSvObyuQyyhNd2XFSyu
        2a6RgGanshA27q+fPd3tA7ll4iCSw7wOUv6qernI05DM+inakBbo0XvdbmI5SDWCtANoQL
        0XRUNd8uHN+3PDA+Hdtg4bQ55723wsg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-LMWvMczGMV2Wddr0LDclBg-1; Mon, 16 Nov 2020 13:09:51 -0500
X-MC-Unique: LMWvMczGMV2Wddr0LDclBg-1
Received: by mail-wm1-f71.google.com with SMTP id y26so48891wmj.7
        for <kvm@vger.kernel.org>; Mon, 16 Nov 2020 10:09:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GIFV53zQFLU+Cuk+mK8udHxZ0BakVben5sR1NOOPdzU=;
        b=jUwbZMZch88LvkWvOgPExrp9PJ/o2ANF/pHIhHrv7GXXJyXSva8od3AzRZ8z7N8A3Y
         /30fXanzOXHu0I4fUeAYqQzWLTHziPn7gfXrJ4qcDbYLJBbz8bKN6mpgrWeJkDIeQ1Bn
         0vOc6Pl2J81aQ11veFlwpihhvVpySDq5XKbHrzH+UU0+yaggYiHgyNbI8Tn7GHUuzIJD
         os1msdK86ZL06HJVgO2OOQamYPA5ov0TNgB+/gGTyKeNWq6GyoSkHDW+naptyRA1+tTF
         PoZ62PmQSNE6Y7Sg2ZJX/zs7znT3xqlnMficJ2Lr96+XxbBOL4Zw+awU5MrnOW1SSqNO
         zl2w==
X-Gm-Message-State: AOAM530FzPygm4//hJfLf+Av2hHZEYkKm9F/1FqWT+RNqT81YbriYfW1
        n8MEGhh/gqWlkBUrCMYPdNJk8P8hVloZYlEU5xI/RwRsXdveK2rgf+hnNSIIOwbPeD5v0x4yhb5
        b/aSBPCJUDrkT
X-Received: by 2002:a05:600c:2244:: with SMTP id a4mr143002wmm.144.1605550190762;
        Mon, 16 Nov 2020 10:09:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx8voa0U785E/TVlZInUE54gWinMnCsSO5znB4tr/qYHX2ypKNC8m+RmnHzV+KwIie+vPZwww==
X-Received: by 2002:a05:600c:2244:: with SMTP id a4mr142982wmm.144.1605550190525;
        Mon, 16 Nov 2020 10:09:50 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m21sm928130wmi.3.2020.11.16.10.09.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 10:09:49 -0800 (PST)
Subject: Re: [PATCH] kvm/i386: Set proper nested state format for SVM
To:     Tom Lendacky <thomas.lendacky@amd.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <fe53d00fe0d884e812960781284cd48ae9206acc.1605546140.git.thomas.lendacky@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a29c92be-d32b-f7c3-ed00-4c3823f8c9a5@redhat.com>
Date:   Mon, 16 Nov 2020 19:09:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <fe53d00fe0d884e812960781284cd48ae9206acc.1605546140.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/11/20 18:02, Tom Lendacky wrote:
> From: Tom Lendacky<thomas.lendacky@amd.com>
> 
> Currently, the nested state format is hardcoded to VMX. This will result
> in kvm_put_nested_state() returning an error because the KVM SVM support
> checks for the nested state to be KVM_STATE_NESTED_FORMAT_SVM. As a
> result, kvm_arch_put_registers() errors out early.
> 
> Update the setting of the format based on the virtualization feature:
>    VMX - KVM_STATE_NESTED_FORMAT_VMX
>    SVM - KVM_STATE_NESTED_FORMAT_SVM

Looks good, but what are the symptoms of this in practice?

Paolo

