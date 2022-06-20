Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B22551161
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 09:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239176AbiFTHVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 03:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235073AbiFTHVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 03:21:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4BD99DF45
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 00:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655709679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pcsdZGC4Bk5dXgiZa8ep5/wweeqwijr7QCScgIhJ8i8=;
        b=Ey1ceSo7IdSO6WQ0xU+amIqhW/yBDqRiIcUhe3kHfBws3tHdwOx8cH/Z7gH0sSbAH5zwq3
        ffhz5rTPnISHLEuFPDWecYDqnlMEmK40lI4q/ZPvKe06VslD93BpE8x090KM2dOjzTCFTP
        HYZlQTjVuoQzgIdUQw4dBMIn8jpZ5sk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-jrwGgFaCPimjg9PBX6hoqQ-1; Mon, 20 Jun 2022 03:21:15 -0400
X-MC-Unique: jrwGgFaCPimjg9PBX6hoqQ-1
Received: by mail-wm1-f69.google.com with SMTP id j31-20020a05600c1c1f00b0039c481c4664so3062561wms.7
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 00:21:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pcsdZGC4Bk5dXgiZa8ep5/wweeqwijr7QCScgIhJ8i8=;
        b=FzbkkAB2TYi2SVfDrYL50UlaSLuV83oUtOWV9Mi03pCqaHJnBcyhPG7o4PkYPhWY87
         mL1pFSGLRPvmu8RocW5iOk90Dka0Usc/Kdx5Dbit6pD7AG7lzIYIqO77yqR5n6fG5htO
         yI6AkmsVdf3OH7uHCTN9xQPJYHUQgKbIX39RgMCwHkl2ahMf217ombc2izxYxSglopQs
         mAQVXC32UuwYqj6WjXiZxfMSMXJStmnSBNHXhosUWG5VIuP49FCNcRrbYitF1zeP7kzr
         sitJQGgYKxyGbLsSX6QACpJPt/JmJDGSMASW61ZQIn9pLBJF4oOgnk+h+H6s9pbMjhhQ
         8LlQ==
X-Gm-Message-State: AJIora/DKnvGzhzSilxk7oG0ShnKFOYQSw4zR6ft1Bm1JoeoY9acNhkz
        aK0k83SUISMvW/njPWrfSiv4O2O5yI6adUHnIdPd8UNGXzZQiAT8lLTgjoz1UTeB9haHsiNmeCp
        luTH3AEnYWb8N
X-Received: by 2002:a5d:5262:0:b0:21b:84a8:8417 with SMTP id l2-20020a5d5262000000b0021b84a88417mr11405776wrc.119.1655709674139;
        Mon, 20 Jun 2022 00:21:14 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1txOi/SXc3CvYBEGxZ+FPzKw9rbDlha6c/GWUp1Y8R77N6vsUCuRy/AIRSU0CexLa25YUvpjQ==
X-Received: by 2002:a5d:5262:0:b0:21b:84a8:8417 with SMTP id l2-20020a5d5262000000b0021b84a88417mr11405759wrc.119.1655709673959;
        Mon, 20 Jun 2022 00:21:13 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id p3-20020a1c5443000000b0039c362311d2sm21441591wmi.9.2022.06.20.00.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 00:21:13 -0700 (PDT)
Date:   Mon, 20 Jun 2022 09:21:11 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com,
        vkuznets@redhat.com, thuth@redhat.com, maz@kernel.org,
        anup@brainfault.org
Subject: Re: [PATCH 2/4] KVM: selftests: Increase UCALL_MAX_ARGS to 7
Message-ID: <20220620072111.ymj2bti6jgw3gsas@gator>
References: <20220615193116.806312-1-coltonlewis@google.com>
 <20220615193116.806312-3-coltonlewis@google.com>
 <20220616121006.ch6x7du6ycevjo5m@gator>
 <Yqy0ZhmF8NF4Jzpe@google.com>
 <Yq0Xpzk2Wa6wBXw9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yq0Xpzk2Wa6wBXw9@google.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 18, 2022 at 12:09:11AM +0000, Sean Christopherson wrote:
> On Fri, Jun 17, 2022, Colton Lewis wrote:
> > On Thu, Jun 16, 2022 at 02:10:06PM +0200, Andrew Jones wrote:
> > > We probably want to ensure all architectures are good with this. afaict,
> > > riscv only expects 6 args and uses UCALL_MAX_ARGS to cap the ucall inputs,
> > > for example.
> > 
> > All architectures use UCALL_MAX_ARGS for that. Are you saying there
> > might be limitations beyond the value of the macro? If so, who should
> > verify whether this is ok?
> 
> I thought there were architectural limitations too, but I believe I was thinking
> of vcpu_args_set(), where the number of params is limited by the function call
> ABI, e.g. the number of registers.
> 
> Unless there's something really, really subtle going on, all architectures pass
> the actual ucall struct purely through memory.  Actually, that code is ripe for
> deduplication, and amazingly it doesn't conflict with Colton's series.  Patches
> incoming...
>

RISC-V uses sbi_ecall() for their implementation of ucall(). CC'ing Anup
for confirmation, but if I understand the SBI spec correctly, then inputs
are limited to registers a0-a5.

Thanks,
drew

