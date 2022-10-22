Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F2C608B45
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 12:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiJVKIF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Oct 2022 06:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiJVKHq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Oct 2022 06:07:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503182D2D4E
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 02:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666430581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=odmDeDwQVjher/qM3oM9cGdcAm/X6A1KhHi4v9Q2U1k=;
        b=Jar0g9O6eVJq1kaZ/HN1zydvcmMGaSwA4XGk4TOQcUk4oEb4Y4YQzI1/vNQ8TaFnqRWBml
        0ZK1fmuAfVAROVpFw07STwKaIZT+zQA+QD8+dxSGktWDK0vktP+FU/e8T5CsmWAUIUbu+f
        iG4crmnlHLpM1uv9juoSPH7ITXf6Xfs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-330-n78TtZ2iOia87R5Hfdh9Uw-1; Sat, 22 Oct 2022 05:09:01 -0400
X-MC-Unique: n78TtZ2iOia87R5Hfdh9Uw-1
Received: by mail-ed1-f69.google.com with SMTP id c9-20020a05640227c900b0045d4a88c750so4871974ede.12
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 02:09:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=odmDeDwQVjher/qM3oM9cGdcAm/X6A1KhHi4v9Q2U1k=;
        b=qZS5rVLbtN6EcTS4upj7oomM3JQMD1UNfGExl3hCWPoKDvp33lf1p/UFFj8VuKQjl8
         oXBxWpFbYcO9X3v6BXEWFJWwFetevkqT0e7FtPCtq4t1azzjG3Rl/u6wgZqie6s48yFx
         xzvMIgbVIXAiOOum9d90PiC6fWimTj3YKyKdSn8rVBI2SDSVxzZiDl02Tq6qtNFHOLxD
         H2zPrJqochr6rt9F5VpNQfAG3HVYOyo42WiE7V5v25OsAjxSoYmoT96RWC7Mv9aUR1lE
         UVcjEIG9tR5IvNOzsLUAH/gWESe+B4839QLW4BJ9/6MU21+tfWKwamSrHJ9/ht2OcLZN
         8GgA==
X-Gm-Message-State: ACrzQf29DcNo4Hhxi7t69EFO6W6iD8zAMdSr2/94LU+yD22/pAfSQGs0
        zW2OZQErfCueR9ZTk8Rwq8pTuIT6oYhOW1LoGRA7RLbwWxp6obym0dlSeGDNiTqMbhNcScf7bid
        b5SVc+5C/7++r
X-Received: by 2002:a17:907:808:b0:730:54cc:b597 with SMTP id wv8-20020a170907080800b0073054ccb597mr19086044ejb.434.1666429740458;
        Sat, 22 Oct 2022 02:09:00 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5wEhhR2mnLJxetCB4SBQ0vEMlRcc1Nv8fTyENEUMtmBOswEAYXdwj/+tYLUYoPRamA0FH1xw==
X-Received: by 2002:a17:907:808:b0:730:54cc:b597 with SMTP id wv8-20020a170907080800b0073054ccb597mr19086033ejb.434.1666429740217;
        Sat, 22 Oct 2022 02:09:00 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:2f4b:62da:3159:e077? ([2001:b07:6468:f312:2f4b:62da:3159:e077])
        by smtp.googlemail.com with ESMTPSA id t5-20020a056402524500b0045726e8a22bsm15111235edd.46.2022.10.22.02.08.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Oct 2022 02:08:59 -0700 (PDT)
Message-ID: <f9327f38-72b3-bf65-a318-bf5982364c15@redhat.com>
Date:   Sat, 22 Oct 2022 11:08:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2 2/2] KVM: debugfs: Return retval of simple_attr_open()
 if it fails
Content-Language: en-US
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <5ddb7c97d2f1edbd000020aa842b0619374e6951.1665975828.git.houwenlong.hwl@antgroup.com>
 <69d64d93accd1f33691b8a383ae555baee80f943.1665975828.git.houwenlong.hwl@antgroup.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <69d64d93accd1f33691b8a383ae555baee80f943.1665975828.git.houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/17/22 05:06, Hou Wenlong wrote:
> Although simple_attr_open() fails only with -ENOMEM with current code
> base, it would be nicer to return retval of simple_attr_open() directly
> in kvm_debugfs_open().
> 
> No functional change intended.
> 
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---
>   virt/kvm/kvm_main.c | 13 ++++++-------
>   1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e30f1b4ecfa5..f7b06c1e8827 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5398,6 +5398,7 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
>   			   int (*get)(void *, u64 *), int (*set)(void *, u64),
>   			   const char *fmt)
>   {
> +	int ret;
>   	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)
>   					  inode->i_private;
>   
> @@ -5409,15 +5410,13 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
>   	if (!kvm_get_kvm_safe(stat_data->kvm))
>   		return -ENOENT;
>   
> -	if (simple_attr_open(inode, file, get,
> -		    kvm_stats_debugfs_mode(stat_data->desc) & 0222
> -		    ? set : NULL,
> -		    fmt)) {
> +	ret = simple_attr_open(inode, file, get,
> +			       kvm_stats_debugfs_mode(stat_data->desc) & 0222
> +			       ? set : NULL, fmt);
> +	if (ret)
>   		kvm_put_kvm(stat_data->kvm);
> -		return -ENOMEM;
> -	}
>   
> -	return 0;
> +	return ret;
>   }
>   
>   static int kvm_debugfs_release(struct inode *inode, struct file *file)

Queued, thanks.

Paolo

