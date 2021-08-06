Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B528B3E2428
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 09:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236069AbhHFHcO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 03:32:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29496 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232808AbhHFHcN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Aug 2021 03:32:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628235117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pVWC3UDptA7H+V1Kg/+VGDadWKlNerXuJRs5msdmzWc=;
        b=RZhsMLBqXDzNvYL/aZr4aClU+Jr1nmFS71BZnyBac0kixbV1q+vqn76qfcbZV7QJd73MqJ
        MH4Hn4/5eS/wP6Pgaf31OLjf+BDE2uOiFA4YD5dokOGv2aEGzjg63/ucLFkJjZS7oKKP5e
        AWH2ehg2p4gnQ2BFp+Ep2kDbxbZem+A=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-Y9bgYxNjPvCP0OCrkiZohQ-1; Fri, 06 Aug 2021 03:31:56 -0400
X-MC-Unique: Y9bgYxNjPvCP0OCrkiZohQ-1
Received: by mail-wm1-f69.google.com with SMTP id k13-20020a05600c1c8db029025018ac4f7dso2160087wms.2
        for <kvm@vger.kernel.org>; Fri, 06 Aug 2021 00:31:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=pVWC3UDptA7H+V1Kg/+VGDadWKlNerXuJRs5msdmzWc=;
        b=g+zTz8gF1fP0Hy7U5Lul+qLQMZDZF0Pm0vUPMDNFotKJS9Uu848FHToitLJyS97nJh
         iekiCCj2RkJ7b+++cgVvmAKHuXrUXdnnUyqWqY7jWhN+f7PSw8R/EBDdd2+hzqVjHJzu
         w98O2fJH6GRQW6vne6oGZkaim5y2I8cC/1L6JTOdOEHG3N2bg5Ih0IMIuAwM79SyHBrD
         1r4IWWQrrKBRazUCVja+e7EGgmzE2PXL4UBQRI2XQs/FfPXquEXCKEl/lMYuXLy15uGM
         guHud8E4p/UiRys4tiCJ+/AgmBWc7wQafwUsq0WQtzRMDPOh+FLT8kXWu7kZveZGXJEx
         9Hcw==
X-Gm-Message-State: AOAM532uRGjhVhitwGOheRNerHdLumpPxBYhE6SAkepBP7AF3I32cf0Y
        lLOtXhtgWBUFaXEfXrWODYJRk2Hx4RzmRAJrUXGJNK1cHTJNR/hz8oGzE38Pj//kNdWd0rk1b9Z
        MZ5hNwhgfYAXz
X-Received: by 2002:adf:d84b:: with SMTP id k11mr9111339wrl.135.1628235115559;
        Fri, 06 Aug 2021 00:31:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxdlvx8qxBMUwmS1NtvHCTtU89EIX8U1VYvVts48XyoDGlCmxjLvN0ZVnYLEfLtdPlwCuIpmw==
X-Received: by 2002:adf:d84b:: with SMTP id k11mr9111324wrl.135.1628235115424;
        Fri, 06 Aug 2021 00:31:55 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6104.dip0.t-ipconnect.de. [91.12.97.4])
        by smtp.gmail.com with ESMTPSA id o24sm9843900wmm.37.2021.08.06.00.31.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 00:31:55 -0700 (PDT)
Subject: Re: [PATCH v3 03/14] KVM: s390: pv: leak the ASCE page when destroy
 fails
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich.Weigand@de.ibm.com
References: <20210804154046.88552-1-imbrenda@linux.ibm.com>
 <20210804154046.88552-4-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <6b75cc71-b996-cf3d-ce57-dbcd475ebc3a@redhat.com>
Date:   Fri, 6 Aug 2021 09:31:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210804154046.88552-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.08.21 17:40, Claudio Imbrenda wrote:
> When a protected VM is created, the topmost level of page tables of its
> ASCE is marked by the Ultravisor; any attempt to use that memory for
> protected virtualization will result in failure.
> 
> Only a successful Destroy Configuration UVC will remove the marking.
> 
> When the Destroy Configuration UVC fails, the topmost level of page
> tables of the VM does not get its marking cleared; to avoid issues it
> must not be used again.
> 
> Since the page becomes in practice unusable, we set it aside and leak it.

Instead of leaking, can't we add it to some list and try again later? Or 
do we only expect permanent errors?

Also, we really should bail out loud (pr_warn) to tell the admin that 
something really nasty is going on.

-- 
Thanks,

David / dhildenb

