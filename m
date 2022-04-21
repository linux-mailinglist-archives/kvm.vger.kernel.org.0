Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21A450A095
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 15:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbiDUNXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 09:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbiDUNXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 09:23:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BFBF5B86D
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 06:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650547214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=LCQ38u6A7MpzQJ92x7kOETUhRB6m7kAQco7/Q/Ua/CC9MSLUdpjvIg7BmRBB5hsybllCmg
        WZw2vCGWZUC6HHqviAiHTZmHUl35HLNmPsZaXUvQ47EipU+R8Cm38sgbkZN2hmeHY+a8Pb
        tndBLfQSVBUssN4BeWWwETFv7aR8hLE=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-098YbIv_Ow-jXAAuRmTQDg-1; Thu, 21 Apr 2022 09:20:13 -0400
X-MC-Unique: 098YbIv_Ow-jXAAuRmTQDg-1
Received: by mail-pj1-f70.google.com with SMTP id q15-20020a17090a178f00b001d33d8130c8so2881863pja.8
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 06:20:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=MRou/tgJLfIZUpmHRu+AGwjLjBGKgpxNN7XAeqU0r9NwSs2uiFGVTu6kXSc5TTjp37
         bBqeuEki+zmS9DWzwMPf9plReGmF9WdMsbaRHaSHi9PRuha4Eugu2C54vb2yRc8w5WyN
         W/uQce2U1nvWk6PdudKIu51zENf9oJFs3uMbON8XHGExqCX7f/RVSFkf+ZMf2SxLGIq1
         GL3SdG8q+mMsf7IRH/vxv5AUgIAkQ5z8Zxinx+xfrS8oPGQirvL6TNNuK940eBqhymcO
         t15Y/jAgT4OU1NkUT67Rg4eXud2ijcifyRCwT0nKZo98ihWifv479XxevtvAnu7XpPsu
         jD2A==
X-Gm-Message-State: AOAM531iczkD5dLp+6B9WiChjtUzv6N74XPpuwbwWxLP/ikZI2f9EMxy
        Rl4pRk2/CqsakTK3ibKmXoUjnQ6EDR7MZaSAtFfLYCtAUg3jtqK07qRpcIyNThKyiAlTOhmwYnc
        r6HQZ5oWE5kf0
X-Received: by 2002:a05:6a00:ccf:b0:50a:db82:4ae5 with SMTP id b15-20020a056a000ccf00b0050adb824ae5mr3581864pfv.59.1650547212331;
        Thu, 21 Apr 2022 06:20:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEg/XKr6Ui9gwh2MQYBfHjjkLlJhmxTVmRmjaeYiITKwKssa5krUtFdDxn4eFPTWFfCNVNig==
X-Received: by 2002:a05:6a00:ccf:b0:50a:db82:4ae5 with SMTP id b15-20020a056a000ccf00b0050adb824ae5mr3581819pfv.59.1650547211962;
        Thu, 21 Apr 2022 06:20:11 -0700 (PDT)
Received: from localhost.localdomain ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id lw3-20020a17090b180300b001cd4989fecesm2984649pjb.26.2022.04.21.06.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 06:20:11 -0700 (PDT)
Date:   Thu, 21 Apr 2022 21:20:00 +0800
From:   Tao Liu <ltao@redhat.com>
To:     joro@8bytes.org
Cc:     cfir@google.com, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, ebiederm@xmission.com,
        erdemaktas@google.com, hpa@zytor.com, jgross@suse.com,
        jroedel@suse.de, jslaby@suse.cz, keescook@chromium.org,
        kexec@lists.infradead.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        luto@kernel.org, martin.b.radev@gmail.com, mhiramat@kernel.org,
        mstunes@vmware.com, nivedita@alum.mit.edu, peterz@infradead.org,
        rientjes@google.com, seanjc@google.com, stable@vger.kernel.org,
        thomas.lendacky@amd.com, virtualization@lists.linux-foundation.org,
        x86@kernel.org
Subject: Re: [PATCH 01/12] kexec: Allow architecture code to opt-out at
 runtime
Message-ID: <YmFaAFcQPhSWNEFz@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721142015.1401-2-joro@8bytes.org>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

