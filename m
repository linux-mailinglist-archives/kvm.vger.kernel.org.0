Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15108610EF3
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 12:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbiJ1KsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 06:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbiJ1KsT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 06:48:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BDC1A402D
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 03:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666954042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hDq1HbvLhh+n0wG0ICvMus6kd7ngVIZaD98ZKD5lL4c=;
        b=Tly3i1cct7vmyjwEUDQQlmKNq5RiDKmgGBdwuAqtk4oPA+Bk7UHCNpsDwcVL0xNqR0FO63
        xv7+YcdRA3/siX239LrgIsQMGXj60xijaiIk3wWfC1uye0NWKgBKdsQR/n0Mdw/e5hL5nM
        GYqVlfJ2lUVVIE1Z5EPTVZou15V2OJE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-44-aAA0l2KjPV2GCzVq2WX6TQ-1; Fri, 28 Oct 2022 06:47:21 -0400
X-MC-Unique: aAA0l2KjPV2GCzVq2WX6TQ-1
Received: by mail-wm1-f72.google.com with SMTP id p39-20020a05600c1da700b003cf608d10ccso406839wms.5
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 03:47:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hDq1HbvLhh+n0wG0ICvMus6kd7ngVIZaD98ZKD5lL4c=;
        b=uuvzVD2a5Ur7YIxzHHT7tHvc/OvwzkiBy2GXRqv6gVKcxAWmmAp9h5N02x73tFHq4a
         LQdkigDVUzFtIf6g8HTdavxkBLlOcwSCqL9FBeVQ42nuzk0gawBBCyjV8JX3MRC+Dvwo
         HHveFrOy00u6WPEf+ZcVdbgS3+bG5dThDcvF8rvnfE91y1Uz5KSFSXCo6u8VOlemjPCA
         d/XO7GXcEeDjMrzjMciaXPjQ6SyHCJT8w6ZlUlS/ZHR2J2PWvcoznZCFTSvWewE5ewSF
         GXqO32jWdSndpbal1O0L7iBV5LU6K/Ll9UnnjwIiYKc6kih5LGCEDa2a/AmpylOMdJji
         MTNg==
X-Gm-Message-State: ACrzQf2Dng4MeKZQndmGx3h4wXLthkXUl9doKLGA/EKpxv0BAFOeoUsK
        o20NZGuWIUgp20P4MtxnwFrvrPuWk5fOPqLAVi93XoRQI9DGfShQ8v52KgBXWh+TTVsmNciRHom
        qLGTEiKLYCKqn
X-Received: by 2002:adf:f511:0:b0:236:60be:e885 with SMTP id q17-20020adff511000000b0023660bee885mr20457323wro.663.1666954039864;
        Fri, 28 Oct 2022 03:47:19 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5/fXxc6OnwaNWfY45NED0RPKuJn4GcdOSO9KoLrfLKSFRh6syx6QiMQVqa+MMXkuoWqVzZ/A==
X-Received: by 2002:adf:f511:0:b0:236:60be:e885 with SMTP id q17-20020adff511000000b0023660bee885mr20457305wro.663.1666954039661;
        Fri, 28 Oct 2022 03:47:19 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id t18-20020a05600001d200b0023647841c5bsm3251599wrx.60.2022.10.28.03.47.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 03:47:19 -0700 (PDT)
Message-ID: <0ecc0739-aa3c-bbf8-b52f-c710cae0675f@redhat.com>
Date:   Fri, 28 Oct 2022 12:47:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] KVM: x86/xen: Fix eventfd error handling in
 kvm_xen_eventfd_assign()
Content-Language: en-US
To:     Eiichi Tsukata <eiichi.tsukata@nutanix.com>, seanjc@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ankur.a.arora@oracle.com, dwmw@amazon.co.uk,
        joao.m.martins@oracle.com
Cc:     syzbot+6f0c896c5a9449a10ded@syzkaller.appspotmail.com
References: <20221028092631.117438-1-eiichi.tsukata@nutanix.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221028092631.117438-1-eiichi.tsukata@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/28/22 11:26, Eiichi Tsukata wrote:
> Should not call eventfd_ctx_put() in case of error.
> 
> Fixes: 2fd6df2f2b47 ("KVM: x86/xen: intercept EVTCHNOP_send from guests")
> Reported-by: syzbot+6f0c896c5a9449a10ded@syzkaller.appspotmail.com
> Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
> ---
>   arch/x86/kvm/xen.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 93c628d3e3a9..a357994982c6 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -1716,7 +1716,7 @@ static int kvm_xen_eventfd_assign(struct kvm *kvm,
>   	if (ret == -ENOSPC)
>   		ret = -EEXIST;
>   out:
> -	if (eventfd)
> +	if (eventfd && !IS_ERR(eventfd))
>   		eventfd_ctx_put(eventfd);
>   	kfree(evtchnfd);
>   	return ret;

Slightly more verbose, but cleaner:

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 6714bbdbedf3..2dae413bd62a 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1666,18 +1666,18 @@ static int kvm_xen_eventfd_assign(struct kvm *kvm,
  	case EVTCHNSTAT_ipi:
  		/* IPI  must map back to the same port# */
  		if (data->u.evtchn.deliver.port.port != data->u.evtchn.send_port)
-			goto out; /* -EINVAL */
+			goto out_noeventfd; /* -EINVAL */
  		break;
  
  	case EVTCHNSTAT_interdomain:
  		if (data->u.evtchn.deliver.port.port) {
  			if (data->u.evtchn.deliver.port.port >= max_evtchn_port(kvm))
-				goto out; /* -EINVAL */
+				goto out_noeventfd; /* -EINVAL */
  		} else {
  			eventfd = eventfd_ctx_fdget(data->u.evtchn.deliver.eventfd.fd);
  			if (IS_ERR(eventfd)) {
  				ret = PTR_ERR(eventfd);
-				goto out;
+				goto out_noeventfd;
  			}
  		}
  		break;
@@ -1717,6 +1717,7 @@ static int kvm_xen_eventfd_assign(struct kvm *kvm,
  out:
	if (eventfd)
  		eventfd_ctx_put(eventfd);
+out_noeventfd:
  	kfree(evtchnfd);
  	return ret;
  }

Only the last goto has to be changed in order to fix the bug, the
others are only needed to respect the LIFO order of the unwinding
labels.

Paolo

