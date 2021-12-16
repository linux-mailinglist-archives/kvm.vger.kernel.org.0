Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C18F476C2B
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 09:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235012AbhLPIri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 03:47:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52600 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232569AbhLPIrh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Dec 2021 03:47:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639644457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3aF2bcZ/YX1nFwYaRdoYyovSpd9ttOChaM2u5O2hEkg=;
        b=O9FUvAi/W45D5hw5FWd9aX6Y3I2oERU9IK5w7t0ZSODMgdb5JhPWAF2SIB3Npwcw5+yV2o
        7uQiyukpRotmxNkfhKqXJIOd9CnFWPATyBsTzVm66Xu8r3EyGU3LTA2zEoPNQpyRnnD9Xp
        bd4nTrYQIofwr1BlONvQjO9UVx7FDGI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-drJDvO_jNwSUSYRErbKXfA-1; Thu, 16 Dec 2021 03:47:36 -0500
X-MC-Unique: drJDvO_jNwSUSYRErbKXfA-1
Received: by mail-wr1-f71.google.com with SMTP id v17-20020adfedd1000000b0017c5e737b02so6652106wro.18
        for <kvm@vger.kernel.org>; Thu, 16 Dec 2021 00:47:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3aF2bcZ/YX1nFwYaRdoYyovSpd9ttOChaM2u5O2hEkg=;
        b=zm5/A6GwNOkJ1tzC2JTTQe/VOKjjjz3X8mGpXHlhQ5civjVgpjj9pQ4HOafA3nh3yb
         xLZiXpmoTNoCrQoEGOvCRidS82IpYoknXwadc5IwDuYcRHZg0976s19PoEOZQM5LtrQE
         9CQ9tPRFC4RkomnBcOIpJB2DTVbDe+2Q/Vi7a91qBthOO8y+DHlVNDVnVueKWgcvWrZ3
         cR3Un2VnwFSCOTwNSmWyK9c9BTeMMCv5s7dvYVvbn+sFp4RmrU2Vz3dhDILA+uRbN7iZ
         45I01ZPFu7dPY5u3r3BqtZ/SE7bCBH97Akz/DHs2/NaCweDdRik9HhqsKNVmCtRPhbIE
         CtjQ==
X-Gm-Message-State: AOAM532Ih8uNXTmI98qJtBJAkrGJwQ8Lj+JQ9Aanzy5ZDJR3peQK1rbD
        1Uou+YEQkZ1iavscVLDSCgHkLkdMOCkef1F6ge10/7lOqvABJjVSLMQYroHrYtrkAYrAOnBcvcV
        e1+F0XFdkasDs
X-Received: by 2002:adf:d1cd:: with SMTP id b13mr8114563wrd.323.1639644455167;
        Thu, 16 Dec 2021 00:47:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwYRPwQ6/aG59Ien/n2wCmHAytBndcwdkmI0hS+IBvughy9MoLzIj45YQrEDoZElO6yEn65Mw==
X-Received: by 2002:adf:d1cd:: with SMTP id b13mr8114543wrd.323.1639644455013;
        Thu, 16 Dec 2021 00:47:35 -0800 (PST)
Received: from xz-m1.local ([64.64.123.12])
        by smtp.gmail.com with ESMTPSA id a9sm4129960wrt.66.2021.12.16.00.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 00:47:34 -0800 (PST)
Date:   Thu, 16 Dec 2021 16:47:28 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/4] intel_iommu: Support IR-only mode without DMA
 translation
Message-ID: <Ybr9IBVQCOrkVHWv@xz-m1.local>
References: <20211209220840.14889-1-dwmw2@infradead.org>
 <20211209220840.14889-2-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211209220840.14889-2-dwmw2@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 09, 2021 at 10:08:38PM +0000, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> By setting none of the SAGAW bits we can indicate to a guest that DMA
> translation isn't supported. Tested by booting Windows 10, as well as
> Linux guests with the fix at https://git.kernel.org/torvalds/c/c40aaaac10
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Acked-by: Claudio Fontana <cfontana@suse.de>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

