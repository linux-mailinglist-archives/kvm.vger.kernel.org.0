Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE5D67500F
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 10:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjATJAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 04:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjATJAG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 04:00:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A424410EC
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 00:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674205155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q2sB4xdBJosD6XKiQZ0jXRIsdlw3NDp1grohf9QuZDc=;
        b=AGTKzaJp5i+zSnmm7nBE7b1iW5lIYkVqSyQiSVps3gyVNnfBJKenzWM1DgToSPdj2FlRFZ
        lbGNaqN7IMgzkuQOVcGYVBXWKlXkgzILtJffo/Sk5TWfbRGGydYn1aZcmIFXll4mW/QoBj
        Xcfvg8tRjSPJ6CKUtg8lJd0+yiPKItE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-413-N3yrdr9kM0ia9zWnm5W3tA-1; Fri, 20 Jan 2023 03:59:11 -0500
X-MC-Unique: N3yrdr9kM0ia9zWnm5W3tA-1
Received: by mail-wm1-f70.google.com with SMTP id fl5-20020a05600c0b8500b003db12112fdeso2653992wmb.5
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 00:59:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=q2sB4xdBJosD6XKiQZ0jXRIsdlw3NDp1grohf9QuZDc=;
        b=T/vedKNe9yO+VVuEHiARBjlQP+k64+Y0rs5M06MqOPPJuWrtcO/ghTl9jHbEoquqmy
         Zf6JR2iqsyEO2QGmJ7a3GxeHsyXeJSVBIPTNVuobcCXI0UUv8FqhBTlxz+CIofjNTKB+
         ffxcOs/fufgFNDNBIc+jMWphNGyuLWoimp2+ZqvvpbkXpPShQDfM8/V3Uu1iIukzVgMI
         lSdbKFQHzlSZ02F3iLL031Bv9Z/X8cSYK0JxqLtfAYrwFILkVjKlpjQm0SGNdYfWoKmk
         T5gew4fi/r11ZUT3r+J6HxbmywD0hfx8oV08amd5OOF/uYGzmuBKFsQnrYELs826OjZb
         IRYw==
X-Gm-Message-State: AFqh2kpLTTLLw5sPSB9N+u0c/eWHm4GzZuSI2gLb4fdgMNNg4YX3xCCt
        fZXX9jFm2J7yC4ZxlZB/uog7LRtbs2pZ5zWowwJ+agCuRf7cGyCtRJttdVEs54d/cdENM9ylnkV
        sYNhJOqyBW6dV
X-Received: by 2002:a05:600c:35d6:b0:3db:2ad:e344 with SMTP id r22-20020a05600c35d600b003db02ade344mr9588750wmq.13.1674205150615;
        Fri, 20 Jan 2023 00:59:10 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt4H+4LG5L38/IWTTmyPX/fEcANlklC8X0hnY9R8KtVdfFvpY+am75qq6FyB1MSYgNzziHQPw==
X-Received: by 2002:a05:600c:35d6:b0:3db:2ad:e344 with SMTP id r22-20020a05600c35d600b003db02ade344mr9588736wmq.13.1674205150352;
        Fri, 20 Jan 2023 00:59:10 -0800 (PST)
Received: from localhost ([2a01:e0a:a9a:c460:ada2:6df5:d1b0:21e])
        by smtp.gmail.com with ESMTPSA id q7-20020a05600c46c700b003db11dfc687sm1688585wmo.36.2023.01.20.00.59.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 00:59:09 -0800 (PST)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 20 Jan 2023 09:59:09 +0100
Message-Id: <CPWW6ZULVEMY.1HWFUQFW6EMSG@fedora>
Cc:     <rjarry@redhat.com>, "Paolo Bonzini" <pbonzini@redhat.com>,
        "Christophe Fontaine" <cfontain@redhat.com>
Subject: Re: [RFC] KVM: x86: Give host userspace control for
 MSR_RAPL_POWER_UNIT and MSR_PKG_POWER_STATUS
From:   "Anthony Harivel" <aharivel@redhat.com>
To:     "Xiaoyao Li" <xiaoyao.li@intel.com>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.13.0-123-g2937830491b5
References: <20230118142123.461247-1-aharivel@redhat.com>
 <d635edea-e181-3498-ceff-72434ab856cf@intel.com>
In-Reply-To: <d635edea-e181-3498-ceff-72434ab856cf@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu Jan 19, 2023 at 6:57 AM CET, Xiaoyao Li wrote:

> Set aside how user space VMM emulate these 2 MSRs correctly, it can=20
> request the MSR READ to exit to user space via KVM_X86_SET_MSR_FILTER.=20
> So user space VMM can just enable the read filter of these 2 MSRs and=20
> provide the emulation itself.

Thanks for your feedback. I totally miss out on this possibility. On
Qemu, only one msr is using it (MSR_CORE_THREAD_COUNT). I did a test
yesterday in Qemu adding a filter with kvm_filter_msr() and a callback
to setup the msr with a dummy value and it's perfectly working.


