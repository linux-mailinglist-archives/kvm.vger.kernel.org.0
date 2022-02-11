Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A105C4B2B6B
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 18:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351913AbiBKRLY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 12:11:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245075AbiBKRLX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 12:11:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CAFD821F
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 09:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644599480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+fH+egNgtrcTN/yo9SnJEosgMHxBzskBNmKpy4+ujzU=;
        b=bT5h8YxAV3U2YdYI7lE9gikbDL/6cAaCWq1XCe4RJifQUotbj4LdZpCOwN/qBiYzwwvCpR
        2jcEZAyvyBtmUV+0OyA17OmqjcVKPMhe5qKKKM8kARCX2jzC9pxBWePTHOWMas0zPe1KmD
        W+OKsKlB2b4lWXgGFCII7sVwETKOhuU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-404-2SDP_I8GNkW6GmM9gi1ZeQ-1; Fri, 11 Feb 2022 12:11:19 -0500
X-MC-Unique: 2SDP_I8GNkW6GmM9gi1ZeQ-1
Received: by mail-ej1-f72.google.com with SMTP id 13-20020a170906328d00b006982d0888a4so4341755ejw.9
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 09:11:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+fH+egNgtrcTN/yo9SnJEosgMHxBzskBNmKpy4+ujzU=;
        b=nK5OURqvIGIfpuGapSwHT/zspqqsrPejLig+RmCkkY3G2ghaVpD5laRza5/3xfYfUw
         LpoqqyMp20ZJL+y9huO5nqGOLgme4M078VKGzje98M6G4TODkc1q9rAFeoh8X+m3xltU
         C8ze68BNxwzvfEYcD2c5tY+UY4kmaapr7wzrzvTN5ffNR4qUslHJg56XVgvNMpmzOCrK
         mEeOt/9uW6xlxmpS5RCxCBNpY1mzv5syCPOVgcB2RxTgABwrNuenNCxshbJaNrNExLCz
         5iOINoJ5NFPge8kY7vlAFVu1/HVgGxsAph+8C70QfAYkOpuzpFJfKtZwjuT/u+ZeCCVn
         Wpqg==
X-Gm-Message-State: AOAM532NfihdSbmrcYtW6/hOzkio8hU6/Q0OAAOsZysDlM9+F2/HtVZR
        uP9DE8UXL0QNfWtZId+shWYhLOZaGOv8wFl0aAAfBDCCMhgfMftjBoWt4P0RPr3IbD1VXgWIexI
        zXXNstvP4V248
X-Received: by 2002:aa7:c418:: with SMTP id j24mr2924131edq.451.1644599477487;
        Fri, 11 Feb 2022 09:11:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwpwFcUYYNnkvRcA/m4GHfj0uOwr5SJjb7uoU4Dl3Wm/sXyNsM619P3/nsOD/l0UxZdqTWSEg==
X-Received: by 2002:aa7:c418:: with SMTP id j24mr2924106edq.451.1644599477274;
        Fri, 11 Feb 2022 09:11:17 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id s16sm9313882edy.70.2022.02.11.09.11.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 09:11:16 -0800 (PST)
Message-ID: <e84b11cc-5961-f8a2-78cb-a3861debe82d@redhat.com>
Date:   Fri, 11 Feb 2022 18:11:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.17, take #3
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, kernel-team@android.com
References: <20220211111129.1180161-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220211111129.1180161-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/11/22 12:11, Marc Zyngier wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.17-3

Pulled, thanks.

Paolo

