Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9363174802C
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 10:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbjGEIyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 04:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbjGEIyT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 04:54:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D389D
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 01:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688547218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JEyFUuSpxw2m67++RhGuJGOEC/oiC8glFPbfTSquf1M=;
        b=X0rVXPHr7caTPQZtEf5eRThA3aZZEINtCvUcL4J/VQaWE0mKwYdSMGRvsYB0/59M+laLPb
        RCBECFyYCMjry67lSqDMt9pTDHdKHm7hMqVl+WJjfKu81ZEEfRKk4aYBudBsli+zMRFBil
        8hYWk7D1CldkQHIGsTp3lQ1gbz6maCc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-14-2WqQdaXsNka7PyPI70BBwQ-1; Wed, 05 Jul 2023 04:53:37 -0400
X-MC-Unique: 2WqQdaXsNka7PyPI70BBwQ-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7659b44990eso549254885a.1
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 01:53:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688547217; x=1691139217;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JEyFUuSpxw2m67++RhGuJGOEC/oiC8glFPbfTSquf1M=;
        b=QzRxsArgBqk1NJncp0Jn0Zv3cW9x215n94BAvQ0UvlYSDp1owsyaPOAxrFzdLekpm4
         GCxf6UIpTFx6/Z72/HsxaDKHJPYQ7lth7UkC78DYibwI18AC9jO22YxvD9ZlZJBeRubR
         8tVa82OJt2fDUWeLUa9qcAGEt7kGvHhqdX8rUTcEPh8oTpr5Wpa+8bqayOCeYF3qU7gy
         Voc/SFLaXtyR/MrB9f7R5QiVLaW88l4xC0JMTGH8jupmWCWsOBdZXzvY0Uim3DuDyRoP
         LKDdXVbF5D59U0Mpa6pdAqcC1b5MEqqXUnET3dRzTu9uZqTaL95M4ZLlHS70Ko8udmNu
         rjKQ==
X-Gm-Message-State: ABy/qLbH+7I6FmeYhyoXBmbuWRalCHvgWXeK7/aOFP6PbpcR4AvnBQ+d
        jB9meWk3dGdLUD1jzyH6fJOewxmYz4uiIYrYvhPIcUEU+sjNeZAfBzg/6Xi+e78l+in3u3VL/93
        +EmIuZXqPsGefCFDjaLAG
X-Received: by 2002:a37:ef11:0:b0:767:35a:5f19 with SMTP id j17-20020a37ef11000000b00767035a5f19mr14196397qkk.14.1688547217371;
        Wed, 05 Jul 2023 01:53:37 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5l+Up1PuHm9a+E1pNEtgMCCz4on7wAJIpTXcsQBkkWCgz0dkqS4GCRKF9kVD3pOGTuatoxSA==
X-Received: by 2002:a37:ef11:0:b0:767:35a:5f19 with SMTP id j17-20020a37ef11000000b00767035a5f19mr14196389qkk.14.1688547217126;
        Wed, 05 Jul 2023 01:53:37 -0700 (PDT)
Received: from [10.33.192.205] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id x9-20020a05620a01e900b00765f8e5ac7csm10127935qkn.48.2023.07.05.01.53.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 01:53:36 -0700 (PDT)
Message-ID: <eb088f47-6b16-d8fc-cddc-b3a8f0e53ffe@redhat.com>
Date:   Wed, 5 Jul 2023 10:53:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-16-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v21 15/20] tests/avocado: s390x cpu topology polarisation
In-Reply-To: <20230630091752.67190-16-pmorel@linux.ibm.com>
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

On 30/06/2023 11.17, Pierre Morel wrote:
> Polarization is changed on a request from the guest.
> Let's verify the polarization is accordingly set by QEMU.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   tests/avocado/s390_topology.py | 46 ++++++++++++++++++++++++++++++++++
>   1 file changed, 46 insertions(+)
> 
> diff --git a/tests/avocado/s390_topology.py b/tests/avocado/s390_topology.py
> index 1758ec1f13..2cf731cb1d 100644
> --- a/tests/avocado/s390_topology.py
> +++ b/tests/avocado/s390_topology.py
> @@ -40,6 +40,7 @@ class S390CPUTopology(QemuSystemTest):
>       The polarization is changed on a request from the guest.
>       """
>       timeout = 90
> +    event_timeout = 1

When running tests in CI and the machines are very loaded, the tests can be 
stalled easily by multiple seconds. So using a timeout of 1 seconds sounds 
way too low for me. Please use at least 5 seconds, or maybe even 10.

>       KERNEL_COMMON_COMMAND_LINE = ('printk.time=0 '
>                                     'root=/dev/ram '
> @@ -99,6 +100,15 @@ def kernel_init(self):
>                            '-initrd', initrd_path,
>                            '-append', kernel_command_line)
>   
> +    def system_init(self):
> +        self.log.info("System init")
> +        exec_command(self, 'mount proc -t proc /proc')
> +        time.sleep(0.2)
> +        exec_command(self, 'mount sys -t sysfs /sys')
> +        time.sleep(0.2)

Hard coded sleeps are ugly... they are prone to race conditions (e.g. on 
loaded test systems), and they artificially slow down the test duration.

What about doing all three commands in one statement instead:

     exec_command_and_wait_for_pattern(self,
            """mount proc -t proc /proc ;
               mount sys -t sysfs /sys ;
               /bin/cat /sys/devices/system/cpu/dispatching""",
            '0')

?

> +        exec_command_and_wait_for_pattern(self,
> +                '/bin/cat /sys/devices/system/cpu/dispatching', '0')
> +
>       def test_single(self):
>           """
>           This test checks the simplest topology with a single CPU.
> @@ -194,3 +204,39 @@ def test_hotplug_full(self):
>           self.check_topology(3, 1, 1, 1, 'high', False)
>           self.check_topology(4, 1, 1, 1, 'medium', False)
>           self.check_topology(5, 2, 1, 1, 'high', True)
> +
> +
> +    def guest_set_dispatching(self, dispatching):
> +        exec_command(self,
> +                f'echo {dispatching} > /sys/devices/system/cpu/dispatching')
> +        self.vm.event_wait('CPU_POLARIZATION_CHANGE', self.event_timeout)
> +        exec_command_and_wait_for_pattern(self,
> +                '/bin/cat /sys/devices/system/cpu/dispatching', dispatching)
> +
> +
> +    def test_polarisation(self):
> +        """
> +        This test verifies that QEMU modifies the entitlement change after
> +        several guest polarization change requests.
> +
> +        :avocado: tags=arch:s390x
> +        :avocado: tags=machine:s390-ccw-virtio
> +        """
> +        self.kernel_init()
> +        self.vm.launch()
> +        self.wait_until_booted()
> +
> +        self.system_init()
> +        res = self.vm.qmp('query-cpu-polarization')
> +        self.assertEqual(res['return']['polarization'], 'horizontal')
> +        self.check_topology(0, 0, 0, 0, 'medium', False)
> +
> +        self.guest_set_dispatching('1');
> +        res = self.vm.qmp('query-cpu-polarization')
> +        self.assertEqual(res['return']['polarization'], 'vertical')
> +        self.check_topology(0, 0, 0, 0, 'medium', False)
> +
> +        self.guest_set_dispatching('0');
> +        res = self.vm.qmp('query-cpu-polarization')
> +        self.assertEqual(res['return']['polarization'], 'horizontal')
> +        self.check_topology(0, 0, 0, 0, 'medium', False)

