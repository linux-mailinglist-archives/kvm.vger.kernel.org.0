Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44307BD9D9
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 13:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346237AbjJILbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 07:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234563AbjJILa6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 07:30:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC52FD56
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 04:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696850983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N7mGg0R3DrljgvJw1y1ejeFG5groXtawWx848a8zT7M=;
        b=XrdL4O1bM3fHXf5ZCBTfkAijxacW6JuzW3PWOUCsyOzmWJuGSZYFlPXsUR+fEEz6lhg16J
        vc16hOFYRsUJafqu/XrQmWh6hMk09SA6gk0L7Pi81+YCOacsv5qRdcGYi0MzIUGjc1rUyZ
        Udg/7dBIU55c3K+jaamy0tFmzKp89VM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-EKZ6g-q_O6aau7yVobq1jQ-1; Mon, 09 Oct 2023 07:29:41 -0400
X-MC-Unique: EKZ6g-q_O6aau7yVobq1jQ-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-418225fb5d6so53364121cf.3
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 04:29:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696850981; x=1697455781;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N7mGg0R3DrljgvJw1y1ejeFG5groXtawWx848a8zT7M=;
        b=YwFRwKkz7sQtO/LTyGmU0B4xMKyYJdMfOGsS+nYXVKtdcmkCpwsIfGjKpcB6nDx9Ou
         F/8qotaUa+8pUUQkCJpyiMhZXCQJ/x7MQ2SLt7C4x4Jhzm2XbHjY76UNl9Sx8RyM40Wg
         YRNnVes0fq8I3pk5g9GBc55xC15mg6oR5TW9H0PmTOB4nt910gcB9yccritPOmBxIWaB
         41JkIQ1CQYG1Hshpd9R62JUebsZzgCbCYKAs65UaOLowqzWA+nUUgWXCULuwRf/BsHhJ
         Zuw4ra5+BScjaN+iHFhpvg7v9i73taNSOO6zKTOnA0I5ysXCZSnM5Ngxb4djH9u+ad9J
         xeAg==
X-Gm-Message-State: AOJu0Yzi5kPPnfSYamnw2ogAHJubaWAsthzGCPrHKx6jwh9VOWuUxofi
        W4Upn9FwEAW085NALTAyXUx/2ooDX2E9qXWIvQ2JZDX9ayf279WQPqqJlSjnBHx6fw+twWKALVY
        1Nmoa4hriZ2J2
X-Received: by 2002:a05:6214:5ece:b0:65c:fec4:30a1 with SMTP id mn14-20020a0562145ece00b0065cfec430a1mr16083507qvb.55.1696850981409;
        Mon, 09 Oct 2023 04:29:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGqNXr7WTdcy5s+sDGx50As8M2XI8LIkeXeM5nKPCfmHcAFZLWCxvpJzCcvYF/o5/ZKNSoq2A==
X-Received: by 2002:a05:6214:5ece:b0:65c:fec4:30a1 with SMTP id mn14-20020a0562145ece00b0065cfec430a1mr16083496qvb.55.1696850981156;
        Mon, 09 Oct 2023 04:29:41 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-176-27.web.vodafone.de. [109.43.176.27])
        by smtp.gmail.com with ESMTPSA id l19-20020a0ce513000000b006616fbcc077sm3811795qvm.129.2023.10.09.04.29.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Oct 2023 04:29:40 -0700 (PDT)
Message-ID: <082a6b8b-6138-bf42-3f5e-0c2995bfe382@redhat.com>
Date:   Mon, 9 Oct 2023 13:29:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [kvm-unit-tests PATCH v1] arch-run: migration: properly handle
 crashing outgoing QEMU
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230926120828.1830840-1-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230926120828.1830840-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/09/2023 14.08, Nico Boehr wrote:
> When outgoing (live) QEMU crashes or times out during migration, we
> currently hang forever.
> 
> This is because we don't exit the loop querying migration state when QMP
> communication fails.
> 
> Add proper error handling to the loop and exit when QMP communication
> fails for whatever reason.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
> Sorry I accidentally sent this only to s390x maintainers and forgot
> Paolo and Andrew, hence resending.
> 
>   scripts/arch-run.bash | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 518607f4b75d..de9890408e24 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -162,8 +162,14 @@ run_migration ()
>   	migstatus=`qmp ${qmp1} '"query-migrate"' | grep return`
>   	while ! grep -q '"completed"' <<<"$migstatus" ; do
>   		sleep 1
> -		migstatus=`qmp ${qmp1} '"query-migrate"' | grep return`
> -		if grep -q '"failed"' <<<"$migstatus" ; then
> +		if ! migstatus=`qmp ${qmp1} '"query-migrate"'`; then
> +			echo "ERROR: Querying migration state failed." >&2
> +			echo > ${fifo}
> +			qmp ${qmp2} '"quit"'> ${qmpout2} 2>/dev/null
> +			return 2
> +		fi
> +		migstatus=`grep return <<<"$migstatus"`
> +		if grep -q '"failed"' <<<"$migstatus"; then
>   			echo "ERROR: Migration failed." >&2
>   			echo > ${fifo}
>   			qmp ${qmp1} '"quit"'> ${qmpout1} 2>/dev/null

Reviewed-by: Thomas Huth <thuth@redhat.com>

and pushed to the repository.

