Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4863D2B71
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 19:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbhGVRL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 13:11:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55339 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229697AbhGVRL6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 13:11:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626976353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dEOxhE/d8Gi5VBU+iwIGqOwgtV0hIHkhjoYTS9cVDoI=;
        b=DG+trCLjiPJfWCXwFVMuWLjvV7IVpWhLf4cHP6ziokQj5+wc6GBiAjv1wb/Pu48xe9K17x
        60j8ZsuVWWASbhwS+AJlm3DICaxCVmuBaYDZb+BMSBZenq3ZO0HnyxB+bFPt0r+rigM12B
        arw19CZGbnWaGEgMEIubc2dD5WUV0qo=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-bqXTtxiFNnioJT3h0Z5iDQ-1; Thu, 22 Jul 2021 13:52:31 -0400
X-MC-Unique: bqXTtxiFNnioJT3h0Z5iDQ-1
Received: by mail-oi1-f198.google.com with SMTP id w134-20020aca498c0000b029025a12f99699so4477699oia.16
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 10:52:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dEOxhE/d8Gi5VBU+iwIGqOwgtV0hIHkhjoYTS9cVDoI=;
        b=tT1nh4HsD0ywpSNQHuCHoiHnzH3ZnA37TzqGkKOwj4mk1LSh1SRx7uzgBsGuLn3GJH
         AFo3nsgC70jyM6BOTyF/rw6Tv7+CfdN8n+z7DF2XQse9/+tD7ctYqEzbMHqLj/+z5yst
         P0CdvZORnZzJCZpDVQmJA/wz6j6RvfJKQZrFvJE7M3rO3vUYTmtBcyB49e0nAUqXnyON
         nNLOiNFhbztRohqaXiK6yyERitSfGdT55axW/MTId8v4RcO77OCuLp7qI6yKqUclCOYE
         4oAZo9ca37N8jQWqmRCLMjg+QYgfTgKN/R+EIKf796J/iHJtppPBdWP6QaKJatGSfG1t
         NLLw==
X-Gm-Message-State: AOAM533oGyufMysSu2gWdrOfCZIglFU7+vsISk+PVtp/XL2KueECd5hr
        lJZmM/UtUWEvZdQp7/Y0NJIi8jGsx7xJlCYFVrSUQlp8lDTq8jDd0Xs0OVPGUR+8LyypfKc7E9U
        MS8kzyWeGBpCx2QX0jY4t0OdWcsZFBTTY8OKUGnJYyhgtM7zHPmMAab9WhlR3iQ==
X-Received: by 2002:a05:6830:242f:: with SMTP id k15mr693656ots.72.1626976350665;
        Thu, 22 Jul 2021 10:52:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyVngI+s525L2IadOp9NPRC/8sx8fKedYJuuVoInHFTAafcxtIaaHGbG3lEZWesX+f+pApHYQ==
X-Received: by 2002:a05:6830:242f:: with SMTP id k15mr693632ots.72.1626976350435;
        Thu, 22 Jul 2021 10:52:30 -0700 (PDT)
Received: from [192.168.0.173] (ip68-102-25-176.ks.ok.cox.net. [68.102.25.176])
        by smtp.gmail.com with ESMTPSA id u19sm28220ote.76.2021.07.22.10.52.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 10:52:29 -0700 (PDT)
From:   Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v2 01/44] target/i386: Expose
 x86_cpu_get_supported_feature_word() for TDX
To:     isaku.yamahata@gmail.com, qemu-devel@nongnu.org,
        pbonzini@redhat.com, alistair@alistair23.me, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, mst@redhat.com, cohuck@redhat.com,
        mtosatti@redhat.com, xiaoyao.li@intel.com, seanjc@google.com,
        erdemaktas@google.com
Cc:     isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <f78aa143d508c5fd0f54da4f31c339e79ebdd105.1625704980.git.isaku.yamahata@intel.com>
Message-ID: <f721d65d-a844-6854-bd89-9e3feb0f8c8f@redhat.com>
Date:   Thu, 22 Jul 2021 12:52:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <f78aa143d508c5fd0f54da4f31c339e79ebdd105.1625704980.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/7/21 7:54 PM, isaku.yamahata@gmail.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Expose x86_cpu_get_supported_feature_word() outside of cpu.c so that it
> can be used by TDX to setup the VM-wide CPUID configuration.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Connor Kuehl <ckuehl@redhat.com>

