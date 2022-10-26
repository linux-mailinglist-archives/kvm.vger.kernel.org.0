Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9756460E57C
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 18:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbiJZQbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 12:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233626AbiJZQbI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 12:31:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90482D8F6F
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 09:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666801866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=M2HRgcaixl1vmoQ7jhurTIL9hqVdP6Nox8K0BT9eQXg1hCs8TGxmMmeXX24HAGFw9D6VL5
        tpkVuUEF9nKDsQOgsrgGDESkgqqrPJIXa3rm7CcMJqZC2yM3ozBSyYshxG70R9T/FufWBv
        qoYATRVvIoT6YjAsP9yoEUVJ5aXXJ9A=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-664-oBGZ7dGhO3W1Bpdlc6HREA-1; Wed, 26 Oct 2022 12:31:05 -0400
X-MC-Unique: oBGZ7dGhO3W1Bpdlc6HREA-1
Received: by mail-wr1-f72.google.com with SMTP id m24-20020adfa3d8000000b00236774fd74aso3461073wrb.8
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 09:31:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=OLl3sheuJz65YZNY2Ve8IvFYAmy1BV+No9soHXF7S5kiCQD0iXU0be3dYdWMl0bds/
         2PUPo511L6ON/bIdq66nFjYzVba+sC9Pw+r1JtDJo+T2urX3MtJc3T+YrpCyJ0CgDUK8
         V7p5wQkBKCydqf2/TZgF6t9wcrmEcZevUc+bzQ9hKMwmSzV3B0Quv2tGy4synj1jcrWP
         ClUfk6LCThNryvVLGJRoi+6YWWtV/p+e27B88Tz05gxHhEWEhEFqQJDYJrNoQrATlf7a
         wFa1ptK1sKXcyGmpujAXHi0r3Zc/mHJ1MRLq75k/aB8eZOfbTpZ3DsnfBmdh6d/K+nqG
         PRaw==
X-Gm-Message-State: ACrzQf0xVczEYJ5YljvPPVWr7ne1iOrfpuhHQbO6ceoAKQ0AtoWItuTi
        rvEWjJ9jhLrFVzPKTWfrXnRg8wUSU4VIAUNV+hR4y43MkBZOTmxgln0lYgEXvLPc0sxPDEyTw7D
        Rl8xCLnkN9k5r
X-Received: by 2002:a05:600c:4ec7:b0:3c6:e3d4:d59d with SMTP id g7-20020a05600c4ec700b003c6e3d4d59dmr3070105wmq.181.1666801864161;
        Wed, 26 Oct 2022 09:31:04 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM53Qxk8pe+041h+gVHRqCVcWzQgGtQn9ZfMb230IwD/XwmIrI1hxUEuEFHTRIipXqcAMYw3Iw==
X-Received: by 2002:a05:600c:4ec7:b0:3c6:e3d4:d59d with SMTP id g7-20020a05600c4ec700b003c6e3d4d59dmr3070082wmq.181.1666801863930;
        Wed, 26 Oct 2022 09:31:03 -0700 (PDT)
Received: from avogadro.local ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.gmail.com with ESMTPSA id l5-20020adfe9c5000000b00236863c02f5sm3958618wrn.96.2022.10.26.09.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 09:31:03 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Gao Chao <chao.gao@intel.com>
Subject: Re: [PATCH v3] target/i386: Set maximum APIC ID to KVM prior to vCPU creation
Date:   Wed, 26 Oct 2022 18:30:59 +0200
Message-Id: <20221026163059.325663-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220825025246.26618-1-guang.zeng@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo

