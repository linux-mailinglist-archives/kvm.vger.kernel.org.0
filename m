Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C913C5A292A
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 16:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbiHZOPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 10:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiHZOPh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 10:15:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBAA20F63
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 07:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661523336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LwkLPif+QP44xUTFalYyNFr7iLnLtUy7KBlEe6+EY28=;
        b=GWyO7eb/KRLvMAbueuGitt0p5RfkPxA+h9V0PjCHdwRi1q7e4lRrRJilPu/1NIjfxT5qGL
        PTSsNIDUQS0NrlRHXLgp4fdm0ARQ/4gaiAG+QPee4xFGvXK8+9TlNjPNF1PODDyWCystRi
        3/QMzqlADI7bwGQX3BzxRgb9t3qlt8Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-202-Q-xgL4T6N72C_71vGgPNjA-1; Fri, 26 Aug 2022 10:15:32 -0400
X-MC-Unique: Q-xgL4T6N72C_71vGgPNjA-1
Received: by mail-wm1-f70.google.com with SMTP id a17-20020a05600c349100b003a545125f6eso4128346wmq.4
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 07:15:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=LwkLPif+QP44xUTFalYyNFr7iLnLtUy7KBlEe6+EY28=;
        b=DQGO+XR5xfs2zzaRpiJGHppsAbM3U+7BKHG8H/hV0m3XRdi6QlPngr9dLI6cW/G7Rp
         KnnBB0NY74/7Yh+yXGgpJ3X2x2oTDopRNeGybQhamhtmAFzRp1Ix5IqiHgWXwfnTgnId
         +09xJ/O7priyos5ybmBKqY+z4KyhCr52V2eeGlLYr2UrnFhrO/4yK5buEMKrSzgg0bv9
         HkVnRmkPgg+WaUEGbvsQFnHu5Of7VNgQp7cV65ewCfHDhpNOkHRAJgtKhbK0OSpMMlDS
         3FwOrQ600b2JrbV5MfQEtFAeuMT8+17/433sHosGXkQrbSObSJXRsEOd1Se9TJhFUrTE
         fYCw==
X-Gm-Message-State: ACgBeo3cCj3joTBV7unc72UmjSK1NmGuRn90WtxopBk45feFLt58d3VL
        aEy6y69hBggiYgZKvIYrt1yBgCumMpslYUYNe8Rsvl08PWXbOR/J4TXe8dJ54Im9HbaWBeVNXrQ
        XpnyDqsZ3IZK0
X-Received: by 2002:a05:600c:3844:b0:3a6:123:5ac5 with SMTP id s4-20020a05600c384400b003a601235ac5mr11261093wmr.102.1661523331587;
        Fri, 26 Aug 2022 07:15:31 -0700 (PDT)
X-Google-Smtp-Source: AA6agR43KQyNATBeoJWQi0IIyIeub6vVLdQjGBm+IMQ3dt/T/dDaSTDEKHGIL03UdiwyI9lVgo+YKQ==
X-Received: by 2002:a05:600c:3844:b0:3a6:123:5ac5 with SMTP id s4-20020a05600c384400b003a601235ac5mr11261077wmr.102.1661523331309;
        Fri, 26 Aug 2022 07:15:31 -0700 (PDT)
Received: from ?IPV6:2003:cb:c708:f600:abad:360:c840:33fa? (p200300cbc708f600abad0360c84033fa.dip0.t-ipconnect.de. [2003:cb:c708:f600:abad:360:c840:33fa])
        by smtp.gmail.com with ESMTPSA id m124-20020a1c2682000000b003a5f783abb8sm8874468wmm.30.2022.08.26.07.15.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 07:15:30 -0700 (PDT)
Message-ID: <6cb75197-1d9e-babd-349a-3e56b3482620@redhat.com>
Date:   Fri, 26 Aug 2022 16:15:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [RFC PATCH 2/2] kvm/kvm-all.c: listener should delay kvm_vm_ioctl
 to the commit phase
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
References: <20220816101250.1715523-1-eesposit@redhat.com>
 <20220816101250.1715523-3-eesposit@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220816101250.1715523-3-eesposit@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16.08.22 12:12, Emanuele Giuseppe Esposito wrote:
> Instead of sending a single ioctl every time ->region_* or ->log_*
> callbacks are called, "queue" all memory regions in a list that will
> be emptied only when committing.
> 

Out of interest, how many such regions does the ioctl support? As many
as KVM theoretically supports? (32k IIRC)

-- 
Thanks,

David / dhildenb

