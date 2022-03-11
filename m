Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218504D67E7
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346741AbiCKRni (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244214AbiCKRng (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:43:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8805F427C9
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647020551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m8EuMd+ZCx5OsVfeiULh+VmESw2UR2DQBIGxB827V/M=;
        b=INrv0MupRev9BBpJBiUsBEaL//DhkUPKm4oLiKCp3OQMmx91f1dO3+yYrFyVn7wZTkRYCO
        4wiNK3jzz5Z6YuEb3qy3gYUjm503rPRfp8DebS0URFu7CqKkuZF6kJzQv4J/rPF/RRl0Tu
        uV1/IbEiIGno4xoi+mjSjqHFbuj/TdE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-WFwdt9zpPOm6spW3P9mh2w-1; Fri, 11 Mar 2022 12:42:30 -0500
X-MC-Unique: WFwdt9zpPOm6spW3P9mh2w-1
Received: by mail-wr1-f71.google.com with SMTP id a11-20020adffb8b000000b001efe754a488so3062121wrr.13
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:42:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:cc:from:in-reply-to
         :content-transfer-encoding;
        bh=m8EuMd+ZCx5OsVfeiULh+VmESw2UR2DQBIGxB827V/M=;
        b=lvWkBD5GIRrySAhlsc1qzG1hDACiYnnqYpETQqo280hvaV1yYJ9WbT1zoL3fC+w6k+
         Z7hSrsHGxLm7NU51iyqqvC84nhJWrdnrh6Rn1Jpzs43Mhkt6agTDtC5wgFvvnvnHXYhb
         /wi9cr3nimJPq4Yogdo8MJ8+JnHHmiI68AnOVWuULZvDt7Pspe8JvXJi1VRmfvLFn5RA
         1LWH8PC3TOrGNnQ+HfevvmYY3gY+N8pJOsQu155A4TXMK/zTAr6i0SKY0/f8axPZ0ShO
         q35kZhDIVn2s4LWYqU66mNGlDrcGbLpC/jrHMyS7y3XxNWDWT96mlol9Sy1j+jNsBzxV
         4n5g==
X-Gm-Message-State: AOAM533iZZMuWtuK0JXCCnImrvWDe7ioOvQUVDuXkrqsXoa/MYFbb7X6
        KNPO7g98k1H8HaeWlg0jscfvfni2aGugX7YADsZS7OoE6azLfNQleuappfGsjcRODQMH7pznyzm
        Q3we9X6O9iFIV
X-Received: by 2002:a05:6000:156f:b0:1f1:f99e:779e with SMTP id 15-20020a056000156f00b001f1f99e779emr8167727wrz.99.1647020549238;
        Fri, 11 Mar 2022 09:42:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwHRFFfWLABHlXTum8G2tMiScgqSro++Z92Sq1PmErX+J5V0F0IoUTrOL9ztvMWm8yhR4iwSA==
X-Received: by 2002:a05:6000:156f:b0:1f1:f99e:779e with SMTP id 15-20020a056000156f00b001f1f99e779emr8167718wrz.99.1647020549015;
        Fri, 11 Mar 2022 09:42:29 -0800 (PST)
Received: from [192.168.8.104] (tmo-098-218.customers.d1-online.com. [80.187.98.218])
        by smtp.gmail.com with ESMTPSA id o19-20020a05600c511300b00389c3a281d7sm15278215wms.0.2022.03.11.09.42.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Mar 2022 09:42:28 -0800 (PST)
Message-ID: <f1a69b25-80db-dae4-b595-e8695a618edc@redhat.com>
Date:   Fri, 11 Mar 2022 18:42:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [kvm-unit-tests PATCH v2 1/3] configure: Fix whitespaces for the
 --gen-se-header help text
Content-Language: en-US
To:     Alexandru Elisei <alexandru.elisei@arm.com>, pbonzini@redhat.com,
        drjones@redhat.com, varad.gautam@suse.com, zixuanwang@google.com,
        kvm@vger.kernel.org
References: <20220223125537.41529-1-alexandru.elisei@arm.com>
 <20220223125537.41529-2-alexandru.elisei@arm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220223125537.41529-2-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/02/2022 13.55, Alexandru Elisei wrote:
> Replace some of the tabs with spaces to display the help text for the
> --gen-se-header option like this:
> 
>      --gen-se-header=GEN_SE_HEADER
>                             Provide an executable to generate a PV header
>                             requires --host-key-document. (s390x-snippets only)
> 
> instead of:
> 
>      --gen-se-header=GEN_SE_HEADER
>                             Provide an executable to generate a PV header
>     requires --host-key-document. (s390x-snippets only)
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>   configure | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/configure b/configure
> index 2d9c3e051103..0ac9c85502ff 100755
> --- a/configure
> +++ b/configure
> @@ -58,7 +58,7 @@ usage() {
>   	                           a PVM image with 'genprotimg' (s390x only)
>   	    --gen-se-header=GEN_SE_HEADER
>   	                           Provide an executable to generate a PV header
> -				   requires --host-key-document. (s390x-snippets only)
> +	                           requires --host-key-document. (s390x-snippets only)
>   	    --page-size=PAGE_SIZE
>   	                           Specify the page size (translation granule) (4k, 16k or
>   	                           64k, default is 64k, arm64 only)

Reviewed-by: Thomas Huth <thuth@redhat.com>

