Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D16C30C874
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 18:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237749AbhBBRuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 12:50:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22597 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237823AbhBBRqA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 12:46:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612287874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FhoUfl+g0uoiRy2j1M8RxEcPRSJNsnmBHDUffwpMaPs=;
        b=bI7iBqyGjfpvlwWaNbGB4o5bZLzKHV+7WN6EQSaPNqycxwIs+Aw+2rdIjfjb+h0+UBm/ko
        pWu9ww+gX5GA4hGEfPE6qkz5A9UB7RdG6gqgZx8ITWDmZn9rNWvHWkh6r0ti/Yry5V+VEA
        VxqkxFhZfVqfUIampAdq68nghYtjZ00=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-SyZlDzuKMvmK8TPuir4uVg-1; Tue, 02 Feb 2021 12:44:32 -0500
X-MC-Unique: SyZlDzuKMvmK8TPuir4uVg-1
Received: by mail-ed1-f69.google.com with SMTP id f4so9942365eds.5
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 09:44:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FhoUfl+g0uoiRy2j1M8RxEcPRSJNsnmBHDUffwpMaPs=;
        b=soTaFziVRi7FKsjNqv+nKExWJ1oBnpjOmaFtEcQi9r5GW2lwR+JWJd+Gqq+p5SJm3O
         ukQepZxDRXZako9opu446V8OryuN51hSPfoRmVDE2vZ1XMuNdMPZx4qllWay7v6tKVxt
         OV5fzSO0ODezpAbFOud3AGSWpQycNy8aqKnpNyDcSo2ekbD0hzo1lW2hJfNBM91ER6NO
         tc8c+ZB4Fi9PTMGxI0BD5ZB7abMsNy0PMcdW4bQNb/H/vq7OKnwn9A6MbH/CHSBLKflo
         GlNUhzQZAN+l0mDvfN7qYXJ3vgpHPG4vW5PAtM2Q1EBwaSxir9oQLSn1V9I50CZr2NXH
         81wg==
X-Gm-Message-State: AOAM532yDt6AReEjOaGFTCHWc+B/gliXzXcNKkzH6YHxMrM9ov4G7nc5
        8bGwAsxl1MVg+YNzQXDBwRExT+JtzZWaGQjFNSk6sHh/d3m8r03WQu7cH3B8UJz3buOt8OowFnH
        HTrWAzt3TfynXyoqq5gAoB/F6O7pAuzzKzjrL3f1Xyent3+VLtPFiPwuqBWcHx0QN
X-Received: by 2002:a17:906:364b:: with SMTP id r11mr12781965ejb.447.1612287870582;
        Tue, 02 Feb 2021 09:44:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwicWvfZ2GLDJ+wwicAsZuRGEGiXNAt178/3YEYrxcL6zuU0sY4SqYCG9xlEoxs/wHQ5j85tg==
X-Received: by 2002:a17:906:364b:: with SMTP id r11mr12781948ejb.447.1612287870342;
        Tue, 02 Feb 2021 09:44:30 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id hh21sm9725201ejb.13.2021.02.02.09.44.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 09:44:29 -0800 (PST)
Subject: Re: [PATCH 2/3] KVM: x86: move kvm_inject_gp up from
 kvm_handle_invpcid to callers
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210202165141.88275-1-pbonzini@redhat.com>
 <20210202165141.88275-3-pbonzini@redhat.com> <YBmOEt6YezYWtTjQ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <986df9f0-9104-04f4-6cd9-db9f996223fc@redhat.com>
Date:   Tue, 2 Feb 2021 18:44:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YBmOEt6YezYWtTjQ@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/02/21 18:38, Sean Christopherson wrote:
> IMO, this isn't an improvement. For flows that can't easily be 
> consolidated to x86.c, e.g. CRs (and DRs?), I agree it makes sense to 
> use kvm_complete_insn_gp(), but this feels forced. What about a pure 
> refactoring of kvm_handle_invpcid() to get a similar effect?

Yes, makes sense.

Paolo

