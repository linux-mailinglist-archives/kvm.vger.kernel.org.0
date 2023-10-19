Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404E17CF598
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 12:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbjJSKqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 06:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbjJSKqW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 06:46:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB16E19E
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 03:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697712336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Lxd5MODsmAGKbTuOienYvfNws4TA5AoutDP3QGe6tEs=;
        b=bcGt6Bnb49FMHZiwUoIcdKDPngcjc732Qjm6vg3XV4KSn7Ty8Oa0vY61lqoS442f5zDzl+
        EFjTPskRDonLUMX5vryBLSwYg6y634H6dlrPCO0v3mrxBaVEK8AzFe79an2VcEGTQ2nGeJ
        RwzV18YFdnUGYLbaFrdtfw2MlovCEiA=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-ZOQ2-D1QMReOH5uURC4qxQ-1; Thu, 19 Oct 2023 06:45:35 -0400
X-MC-Unique: ZOQ2-D1QMReOH5uURC4qxQ-1
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-7b61b80e901so2019901241.2
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 03:45:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697712335; x=1698317135;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lxd5MODsmAGKbTuOienYvfNws4TA5AoutDP3QGe6tEs=;
        b=W6rIZFfw5m5Ct3mdLVJ6kttVlvYFoRONnRv/d0xZ+3jrXNvarvsSHeINQMzFEHOeLG
         84W+s862l4aADKdhDNz87Sh9vN2TdgG45I6A/ByHsvsV0zwGVaT/DvtUEo2QzvCLHlg+
         nXvUaqVVIqt4gwSI8YISxhgNo65nhIltRfvL7K05RuPSDdOmuBHE+PdotDHpkbh/Q8To
         4i4Sn10mdI5MvVa+8S3R0v1PQLY8qErDCh5GigqW/qX37LVlt1mnwWjC4Gw12mi5NusO
         NQZF9pVxEc2Ig9+usvGZtZBYjm4/vqNGzb76E3mOu5vkjKuyK0iO129SI24Jsb9qhbai
         XcEw==
X-Gm-Message-State: AOJu0Yxi2PXlrj8fkID+dzE5gl2UdF5p4JkIB23lqhBY0y4QfD7SV0Pi
        oCs4beV+3NSAGY7rl0QoCqlxq3sR1bkTa0cF8pXXR8lbBLyyYRqmu667glNCKDF3Uk34G7GVAq9
        sWr8P8ZFKCanv
X-Received: by 2002:a67:b702:0:b0:44e:ac98:c65d with SMTP id h2-20020a67b702000000b0044eac98c65dmr1269382vsf.27.1697712335132;
        Thu, 19 Oct 2023 03:45:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFYky3whGsAgdNN+wxhIzNqJbdy0LW6MrG6Q0VPEs7UbfeSBAf1GMlgRpft6IJk9K4PeYFSrA==
X-Received: by 2002:a67:b702:0:b0:44e:ac98:c65d with SMTP id h2-20020a67b702000000b0044eac98c65dmr1269373vsf.27.1697712334816;
        Thu, 19 Oct 2023 03:45:34 -0700 (PDT)
Received: from rh (p200300c93f0047001ec25c15da4a4a7b.dip0.t-ipconnect.de. [2003:c9:3f00:4700:1ec2:5c15:da4a:4a7b])
        by smtp.gmail.com with ESMTPSA id em17-20020ad44f91000000b0064f43efc844sm687385qvb.32.2023.10.19.03.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Oct 2023 03:45:34 -0700 (PDT)
Date:   Thu, 19 Oct 2023 12:45:30 +0200 (CEST)
From:   Sebastian Ott <sebott@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 08/12] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
In-Reply-To: <CAJHc60z7U1-irTy-6URb_V0PTW+TYS4qodf2akSg33_7CJgjyw@mail.gmail.com>
Message-ID: <f7cd9b3d-c817-7082-d60a-a529e1c82f1e@redhat.com>
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-9-rananta@google.com> <5d35c9f3-455e-6aa9-fd6a-4433cf70803a@redhat.com> <CAJHc60z7U1-irTy-6URb_V0PTW+TYS4qodf2akSg33_7CJgjyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463795790-1917350782-1697712334=:15494"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795790-1917350782-1697712334=:15494
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 17 Oct 2023, Raghavendra Rao Ananta wrote:
> On Tue, Oct 17, 2023 at 8:52 AM Sebastian Ott <sebott@redhat.com> wrote:
>>
>> On Mon, 9 Oct 2023, Raghavendra Rao Ananta wrote:
>>> +static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
>>> +                 u64 val)
>>> +{
>>> +     struct kvm *kvm = vcpu->kvm;
>>> +     u64 new_n, mutable_mask;
>>> +
>>> +     mutex_lock(&kvm->arch.config_lock);
>>> +
>>> +     /*
>>> +      * Make PMCR immutable once the VM has started running, but do
>>> +      * not return an error (-EBUSY) to meet the existing expectations.
>>> +      */
>>
>> Why should we mention which error we're _not_ returning?
>>
> Oh, it's not to break the existing userspace expectations. Before this
> series, any 'write' from userspace was possible. Returning -EBUSY all
> of a sudden might tamper with this expectation.

Yes I get that part. What I've meant is why specifically mention -EBUSY?
You're also not returning -EFAULT nor -EINVAL.

/*
  * Make PMCR immutable once the VM has started running, but do
  * not return an error to meet the existing expectations.
  */
IMHO provides the same info to the reader and is less confusing

Sebastian
---1463795790-1917350782-1697712334=:15494--

