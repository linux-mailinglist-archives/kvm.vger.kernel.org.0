Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32AE5275C62
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 17:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgIWPvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 11:51:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35625 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgIWPvR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 11:51:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600876276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dj6jcu+pPzMTXwmvY6d1MA+ijx8SMYhqyWnRY9I7FdA=;
        b=Egmx2xpKZAE64BBLPOt4tDHWaer8VqwVO+DQRLf+SBvHNu0RU1cvp4hGDd6S4yRgJk8Lv5
        ny17cJD0BbbMilIOdjGI+8E55mKmMRgFuqLbfYP2HHuiO1ZRQNkSv9uz46rrmCDSA2Ezmc
        M2ZZkkC8IaHlFgrhyaz6DZMl1tJlPPI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-rrB5xT5HO3q69k590u6sWA-1; Wed, 23 Sep 2020 11:51:12 -0400
X-MC-Unique: rrB5xT5HO3q69k590u6sWA-1
Received: by mail-wm1-f70.google.com with SMTP id b20so2479493wmj.1
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 08:51:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dj6jcu+pPzMTXwmvY6d1MA+ijx8SMYhqyWnRY9I7FdA=;
        b=Gw6Smp4aXo5GxhyPof/yjOegvlYU+hCW9UyeyDPuYE9bheEMOYHZvIMCfREvBz2STc
         KD7T9xAvfrtbacvM3vv5T6onuGs5DyxZBIsn+r+B0xiwJpoOWcJOPg1wQk7OoJnlvgbB
         k8cOrrUk3iRadTlTdX4EmSoZdRXtgpsYplnfnvgl06IqN7px2uuufKEQCoDbQE5wgn3m
         9DLCJLQqKTxtYHeM163zqkvGjAB6kUm0nOEQSyG2EUkfb5Hgcj2bVgNQ1Il950x1QieF
         kEEeTJWR+/lTp9VU3zoNTJGSlTVPT95TkG8d6sbN0E7JOUT6/wUp83g6kqBzCtperr81
         hGRQ==
X-Gm-Message-State: AOAM530xov2aX63ZaDR4cRfwsubsFPhxvQAPVQG2HCbhGau3DSPseJ5m
        Zy59GTSziDhH28BMOItsxvB2Ooydv2mXiC7mtLQQxLFTxGR6Aye+ZKN4DwCVWrTPwWS3vpwK35W
        OLwVzvvSupgVk
X-Received: by 2002:a7b:cf1a:: with SMTP id l26mr208615wmg.164.1600876271618;
        Wed, 23 Sep 2020 08:51:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1WIm9uEoMBECf+32Q0gTViJ7lcU9emrdw/lTmHxrD5OIOmqqaW68jE/6Qz8QMbOqTqcpKlg==
X-Received: by 2002:a7b:cf1a:: with SMTP id l26mr208600wmg.164.1600876271427;
        Wed, 23 Sep 2020 08:51:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:15f1:648d:7de6:bad9? ([2001:b07:6468:f312:15f1:648d:7de6:bad9])
        by smtp.gmail.com with ESMTPSA id t202sm244078wmt.14.2020.09.23.08.51.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 08:51:10 -0700 (PDT)
Subject: Re: KVM: x86: emulating RDPID failure shall return #UD rather than
 #GP
To:     Robert Hoo <robert.hu@linux.intel.com>,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        kvm@vger.kernel.org
Cc:     robert.hu@intel.com
References: <1598581422-76264-1-git-send-email-robert.hu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fd9ae8b0-1e64-aa63-1c98-db534f3fcc6e@redhat.com>
Date:   Wed, 23 Sep 2020 17:51:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1598581422-76264-1-git-send-email-robert.hu@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/08/20 04:23, Robert Hoo wrote:
> Per Intel's SDM, RDPID takes a #UD if it is unsupported, which is more or
> less what KVM is emulating when MSR_TSC_AUX is not available.  In fact,
> there are no scenarios in which RDPID is supposed to #GP.
> 
> Fixes: fb6d4d340e (KVM: x86: emulate RDPID)
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> ---
>  arch/x86/kvm/emulate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index d0e2825..571cb86 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3594,7 +3594,7 @@ static int em_rdpid(struct x86_emulate_ctxt *ctxt)
>  	u64 tsc_aux = 0;
>  
>  	if (ctxt->ops->get_msr(ctxt, MSR_TSC_AUX, &tsc_aux))
> -		return emulate_gp(ctxt, 0);
> +		return emulate_ud(ctxt);
>  	ctxt->dst.val = tsc_aux;
>  	return X86EMUL_CONTINUE;
>  }
> 

Queued, thanks.

Paolo

