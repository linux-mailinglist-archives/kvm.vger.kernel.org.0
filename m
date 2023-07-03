Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4CD745D46
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 15:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbjGCN2t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 09:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjGCN2s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 09:28:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29728E3
        for <kvm@vger.kernel.org>; Mon,  3 Jul 2023 06:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688390883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ycsPEf+hk8Q2JnOBMERVIv1v1bxnQ/4XY8nDOt3hLFE=;
        b=cSMhxyW41m4t5Q4N9WErBHPb/CLNqMsrOyV3IiJsxyv6rtxbgM+7UtTTzjCq7ECF/a7WAa
        AzUuuRBa52Ay8BYgmQlC7NFaFEOBhDE4GBeUSRiwAKN28grmlEe9mcroaHvONRZb6KYG2/
        6o+EzrBomK60Rhkmd0sNL7ihmtVHuR4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-GkKvZ6LYNCyf4pS_1ohCFg-1; Mon, 03 Jul 2023 09:28:02 -0400
X-MC-Unique: GkKvZ6LYNCyf4pS_1ohCFg-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-40343567c4eso18047061cf.0
        for <kvm@vger.kernel.org>; Mon, 03 Jul 2023 06:28:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688390882; x=1690982882;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ycsPEf+hk8Q2JnOBMERVIv1v1bxnQ/4XY8nDOt3hLFE=;
        b=YDtl7rpmr7czos75m+5sL5zX01ZYELX4NKP1Wr1CYEBe3wOrFHSRwNYObJ9TSd4idK
         SAtmOF/Tw4lAWP7DA9ET2H4d9vvm6H2hXteVHmkXATTnOkOFd30L66n8HGH+oQiLF7sj
         NCbET0+ZChtMJ2fZSlH7TIAaf7B6As3dl6y093vkfueNgf0d3qlckKoz1XOO+vf+21py
         Qrw+stiish2xJh4mxe0K4+ovFH+x9pi8FZiBX0krDmolmtL+Dw2BLue3vd4/6VhFYpyV
         ESUelWvVd3AtOV25QfuzLcpsvOGAqOl4gv3ek5bLPdWYN2OWqVVEmW2UF6Z82Gon/Ms8
         gocQ==
X-Gm-Message-State: AC+VfDxEDcRPYkr739r3osfRfOg0rux8BjPGfNlBRO3p8lVKRglZPkLp
        L2aITpNXwBYX5mQ1FBmogtBXPHG9bgE1HKumbIVw+VAau8rmK5e2L+JUFk9N+uxPz+/LrXdhp3G
        8gzYkrIRWAoIg
X-Received: by 2002:a05:622a:1392:b0:400:9a53:75cf with SMTP id o18-20020a05622a139200b004009a5375cfmr18644556qtk.30.1688390881804;
        Mon, 03 Jul 2023 06:28:01 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5pGep0ZvHdyMHlfEcnPcwLb3nLyZyg6SGhfYHWcOPFIl3YZF8OBAcIezkPj1r9OSXjvN/daw==
X-Received: by 2002:a05:622a:1392:b0:400:9a53:75cf with SMTP id o18-20020a05622a139200b004009a5375cfmr18644535qtk.30.1688390881548;
        Mon, 03 Jul 2023 06:28:01 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-176-127.web.vodafone.de. [109.43.176.127])
        by smtp.gmail.com with ESMTPSA id n7-20020ac81e07000000b004033992e2dbsm4891888qtl.45.2023.07.03.06.28.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jul 2023 06:28:01 -0700 (PDT)
Message-ID: <f2d4d019-4a77-7ba9-d564-6e39b194a5d8@redhat.com>
Date:   Mon, 3 Jul 2023 15:27:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>
References: <20230608075826.86217-1-npiggin@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests v4 00/12] powerpc: updates, P10, PNV support
In-Reply-To: <20230608075826.86217-1-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/2023 09.58, Nicholas Piggin wrote:
> Posting again, a couple of patches were merged and accounted for review
> comments from last time.

Sorry for not being very responsive ... it's been a busy month.

Anyway, I've now merged the first 5 patches and the VPA test since they look 
fine to me.

As Joel already wrote, there is an issue with the sprs patch, I also get an 
error with the PIR register on the P8 box that I have access to as soon as I 
apply the "Specify SPRs with data rather than code" patch. It would be good 
to get that problem resolved before merging the remaining patches...

  Thomas


