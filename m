Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56F15B3CF1
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 18:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbiIIQZ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 12:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiIIQZp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 12:25:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966BA136CF3
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 09:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662740743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iqg92T6+DIsD3HEOljmpjoovmZlRQMOWaRSmystH/zs=;
        b=I5fQt2oKz0/QVi/LbpWpWocJ8PBIeTLuekBJ6OiS8Om0PHfHiqDbhx/zS5ze2HF71MHajF
        jo1/eXsqsB3HJvBzX6isHEkBzKY+cZzDhzKNq0CoEfTc+3T1nexS3W+ZeWPI3ftzKhAF3a
        BScjXBHOpobkXE5RZX+FQpycWmL0M3M=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-144-5rBM4QFLNAO2H8JpJOsh1w-1; Fri, 09 Sep 2022 12:25:42 -0400
X-MC-Unique: 5rBM4QFLNAO2H8JpJOsh1w-1
Received: by mail-qk1-f200.google.com with SMTP id h8-20020a05620a284800b006b5c98f09fbso1873409qkp.21
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 09:25:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=iqg92T6+DIsD3HEOljmpjoovmZlRQMOWaRSmystH/zs=;
        b=QTIlb8+7hOzd1xoeXU+T2PqNswlMlhkX6LMAP6kqKTRAr36ilcav0RfYbnKCt8OZ+6
         21YOr4KLkYCI2IPB+tdnsPOjbyz8XFRgIOJgvnYOqqePe+9oGITn/qjDkxC2qdboRXal
         4DKHXNF1FuIDkAxGoYtau38M+x68FmypRh/eLH2SI4S+Cy/leAl0BRr//gHncvY3mZAJ
         YdKwl6xquRBjAdrjpjwqMxaySOG5n1BNvAjJWUujZp2k2fiSFy+0GwivxykwFdOOeh+W
         wPTFbP4PI7AGjEq8AZc30B0qkiDHCfWqsQ+Eeqxm62DeXC1VSifMTceJG3J0f98bh1R/
         3eAQ==
X-Gm-Message-State: ACgBeo3/ZZmcyTQO/F3z5P8APzySX6iWLDkPN3QAKKjUKBF2A/ZmZHkT
        PTbPJqrmYY3qAQL+lufPZCimyEnIzMvimMEInVAOTuxrlGFjufeWflXrBMi2it4EPkO+J41sFPM
        L7zwS3aLfP9KP
X-Received: by 2002:a05:620a:172b:b0:6bb:3dea:1fd with SMTP id az43-20020a05620a172b00b006bb3dea01fdmr10375446qkb.683.1662740742148;
        Fri, 09 Sep 2022 09:25:42 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6n2O7RQP3m3YHIPv2uiMg0nXQxbZoxEAbEDGoaL6WVD66pXUnx5xegwqJGTCORAEgZyyyzOw==
X-Received: by 2002:a05:620a:172b:b0:6bb:3dea:1fd with SMTP id az43-20020a05620a172b00b006bb3dea01fdmr10375433qkb.683.1662740741925;
        Fri, 09 Sep 2022 09:25:41 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id d14-20020a05620a240e00b006cc190f627bsm884222qkn.63.2022.09.09.09.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 09:25:41 -0700 (PDT)
Date:   Fri, 9 Sep 2022 12:25:40 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v5 3/3] i386: Add notify VM exit support
Message-ID: <YxtpBMZmrDK3cghT@xz-m1.local>
References: <20220817020845.21855-1-chenyi.qiang@intel.com>
 <20220817020845.21855-4-chenyi.qiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220817020845.21855-4-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022 at 10:08:45AM +0800, Chenyi Qiang wrote:
> There are cases that malicious virtual machine can cause CPU stuck (due
> to event windows don't open up), e.g., infinite loop in microcode when
> nested #AC (CVE-2015-5307). No event window means no event (NMI, SMI and
> IRQ) can be delivered. It leads the CPU to be unavailable to host or
> other VMs. Notify VM exit is introduced to mitigate such kind of
> attacks, which will generate a VM exit if no event window occurs in VM
> non-root mode for a specified amount of time (notify window).
> 
> A new KVM capability KVM_CAP_X86_NOTIFY_VMEXIT is exposed to user space
> so that the user can query the capability and set the expected notify
> window when creating VMs. The format of the argument when enabling this
> capability is as follows:
>   Bit 63:32 - notify window specified in qemu command
>   Bit 31:0  - some flags (e.g. KVM_X86_NOTIFY_VMEXIT_ENABLED is set to
>               enable the feature.)
> 
> Because there are some concerns, e.g. a notify VM exit may happen with
> VM_CONTEXT_INVALID set in exit qualification (no cases are anticipated
> that would set this bit), which means VM context is corrupted. To avoid
> the false positive and a well-behaved guest gets killed, make this
> feature disabled by default. Users can enable the feature by a new
> machine property:
>     qemu -machine notify_vmexit=on,notify_window=0 ...

The patch looks sane to me; I only read the KVM interface, though.  Worth
add a section to qemu-options.hx?  It'll also be worthwhile to mention the
valid range of notify_window and meaning of zero (IIUC that's also a valid
input, just use the hardware default window size).

Thanks,

> 
> A new KVM exit reason KVM_EXIT_NOTIFY is defined for notify VM exit. If
> it happens with VM_INVALID_CONTEXT, hypervisor exits to user space to
> inform the fatal case. Then user space can inject a SHUTDOWN event to
> the target vcpu. This is implemented by injecting a sythesized triple
> fault event.

-- 
Peter Xu

