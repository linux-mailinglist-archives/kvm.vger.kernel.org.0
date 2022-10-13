Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E53F5FDAB4
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 15:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiJMNWR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 09:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiJMNWP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 09:22:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0DFE52E6
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 06:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665667332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Np/xKXltzXPRoyGoqjxon73Wso5Ilyk/NloINlOdpl0=;
        b=RsG9iAJP05E7ukfTbW4dpkkeTzfYT+Gg5bdF3ym+Rdc/64O4UYT3kTVnwkrDqlFG9J2ApT
        pBlFbwz4FhG/dx+ibwfi/nFOuw8qsVdY0s/dMGf6XcCUjubgx5WxKQ2j7bscP/EYmHDlvl
        GZVKZkf2KVx0PsvdgcF0qopYAkRoaws=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-120-6iscpEpxMIezI6TveCrShA-1; Thu, 13 Oct 2022 09:22:11 -0400
X-MC-Unique: 6iscpEpxMIezI6TveCrShA-1
Received: by mail-wm1-f71.google.com with SMTP id c5-20020a1c3505000000b003c56da8e894so2896592wma.0
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 06:22:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Np/xKXltzXPRoyGoqjxon73Wso5Ilyk/NloINlOdpl0=;
        b=pLgeGJU8ByjIVd2IqznVZFjZGlh/CUx9RQL8xXqf00dAwyLGiyO2U9rJDwF+tA0T1v
         JOhg4hEXQQHDK32XVNRDVIoetu/JsAHOEec3rG3Fp8rQAjVqaenAaTBTEqhX0UVhtSBB
         e8mO52wWs3KY1Pyg6Vtt2PV3gh33QvvLPA8HTAOFFlzyy10HPqYnVcA6luEZOJIVu8M/
         YulZoG3zc16l3oLyUgeXn8aZvyQz0+3AGhX1NgKsqiH4arQ3siuzCmycCXA+9kI6zvXL
         6L3l7r2eHakJNpeow1RLNkT69jfy559TLKZ4KWhdFOwoiUXB6OUoMPRDvefHm5j5UHXk
         Qfcg==
X-Gm-Message-State: ACrzQf3bVId088gQFeVzoHjEDyBeQ7TjfKWCryJGr3DFca21GsaBYpui
        HPGE6NILMl74k7MnGAzmQHPI3+K5d2KMM5DVBh2yctOY/1BCyVwO3sSyjuF6giKmUoJ5gTvrezh
        JoEgrav+EfSsY
X-Received: by 2002:a5d:6ac3:0:b0:22e:657f:2e54 with SMTP id u3-20020a5d6ac3000000b0022e657f2e54mr22381584wrw.73.1665667330506;
        Thu, 13 Oct 2022 06:22:10 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6aVznmZ0I0KtaxkOYpmw5P7CS87aTQGXssjZIvQv0UwJ6Tyd3a9OGWQ157Yxn/Y4uxAobhmw==
X-Received: by 2002:a5d:6ac3:0:b0:22e:657f:2e54 with SMTP id u3-20020a5d6ac3000000b0022e657f2e54mr22381567wrw.73.1665667330251;
        Thu, 13 Oct 2022 06:22:10 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id z10-20020a05600c0a0a00b003a2f2bb72d5sm6550770wmp.45.2022.10.13.06.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 06:22:09 -0700 (PDT)
Date:   Thu, 13 Oct 2022 14:22:07 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Michael Roth <michael.roth@amd.com>
Subject: Re: [PATCH 1/4] qapi, i386/sev: Change the reduced-phys-bits value
 from 5 to 1
Message-ID: <Y0gQ/3Vx7Y8KOhQH@work-vm>
References: <cover.1664550870.git.thomas.lendacky@amd.com>
 <cb96d8e09154533af4b4e6988469bc0b32390b65.1664550870.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb96d8e09154533af4b4e6988469bc0b32390b65.1664550870.git.thomas.lendacky@amd.com>
User-Agent: Mutt/2.2.7 (2022-08-07)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Tom Lendacky (thomas.lendacky@amd.com) wrote:
> A guest only ever experiences, at most, 1 bit of reduced physical
> addressing. Change the query-sev-capabilities json comment to use 1.
> 
> Fixes: 31dd67f684 ("sev/i386: qmp: add query-sev-capabilities command")
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  qapi/misc-target.json | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/qapi/misc-target.json b/qapi/misc-target.json
> index 4944c0528f..398fd09f25 100644
> --- a/qapi/misc-target.json
> +++ b/qapi/misc-target.json
> @@ -172,7 +172,7 @@
>  # -> { "execute": "query-sev-capabilities" }
>  # <- { "return": { "pdh": "8CCDD8DDD", "cert-chain": "888CCCDDDEE",
>  #                  "cpu0-id": "2lvmGwo+...61iEinw==",
> -#                  "cbitpos": 47, "reduced-phys-bits": 5}}
> +#                  "cbitpos": 47, "reduced-phys-bits": 1}}
>  #
>  ##
>  { 'command': 'query-sev-capabilities', 'returns': 'SevCapability',
> -- 
> 2.37.3
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

