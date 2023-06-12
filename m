Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5516E72C31F
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 13:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbjFLLjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 07:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236430AbjFLLiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 07:38:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFB97A9F
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 04:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686568727;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=36d2tYssi0iWXab/pB5scxxolTXYqFelDGqk9IVpbfg=;
        b=ev+2P/mPnXdwfkmxWrlKuBIUnSq9C7kApoLdcwqTBg309SU+XUl5ZZPrZsfAqWMoMS8UW4
        WRz8/kjGq6zHjXxst3mX28nyXl8R1dpLkmWX2tJR2WVMxmPMod51hg0D3eQIWw3nT0IHnW
        HbwdUF9uc3zglIi6YK8NrVSbLM9CkI0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-WFFF9uCqO_iBEVhnCIfLcQ-1; Mon, 12 Jun 2023 07:18:44 -0400
X-MC-Unique: WFFF9uCqO_iBEVhnCIfLcQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05E838032FE;
        Mon, 12 Jun 2023 11:18:44 +0000 (UTC)
Received: from [10.64.54.97] (vpn2-54-97.bne.redhat.com [10.64.54.97])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 83EFB492CAC;
        Mon, 12 Jun 2023 11:18:41 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] runtime: Allow to specify properties for
 accelerator
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        nrb@linux.ibm.com, thuth@redhat.com, shan.gavin@gmail.com
References: <20230612050708.584111-1-gshan@redhat.com>
 <20230612-4c2e1b03885ddc0f55eb1988@orel>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <46ee043a-1ef4-4786-459c-f1b9e6fe7e96@redhat.com>
Date:   Mon, 12 Jun 2023 21:18:39 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20230612-4c2e1b03885ddc0f55eb1988@orel>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 6/12/23 6:27 PM, Andrew Jones wrote:
> On Mon, Jun 12, 2023 at 03:07:08PM +1000, Gavin Shan wrote:
>> There are extra properties for accelerators to enable the specific
>> features. For example, the dirty ring for KVM accelerator can be
>> enabled by "-accel kvm,dirty-ring-size=65536". Unfortuntely, the
>> extra properties for the accelerators aren't supported. It makes
>> it's impossible to test the combination of KVM and dirty ring
>> as the following error message indicates.
>>
>>    # cd /home/gavin/sandbox/kvm-unit-tests/tests
>>    # QEMU=/home/gavin/sandbox/qemu.main/build/qemu-system-aarch64 \
>>      ACCEL=kvm,dirty-ring-size=65536 ./its-migration
>>       :
>>    BUILD_HEAD=2fffb37e
>>    timeout -k 1s --foreground 90s /home/gavin/sandbox/qemu.main/build/qemu-system-aarch64 \
>>    -nodefaults -machine virt -accel kvm,dirty-ring-size=65536 -cpu cortex-a57             \
>>    -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd   \
>>    -device pci-testdev -display none -serial stdio -kernel _NO_FILE_4Uhere_ -smp 160      \
>>    -machine gic-version=3 -append its-pending-migration # -initrd /tmp/tmp.gfDLa1EtWk
>>    qemu-system-aarch64: kvm_init_vcpu: kvm_arch_init_vcpu failed (0): Invalid argument
>>
>> Allow to specify extra properties for accelerators. With this, the
>> "its-migration" can be tested for the combination of KVM and dirty
>> ring.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arm/run               | 4 ++--
>>   scripts/arch-run.bash | 4 ++--
>>   2 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/arm/run b/arm/run
>> index c6f25b8..bbf80e0 100755
>> --- a/arm/run
>> +++ b/arm/run
>> @@ -35,13 +35,13 @@ fi
>>   
>>   M='-machine virt'
>>   
>> -if [ "$ACCEL" = "kvm" ]; then
>> +if [[ "$ACCEL" =~ ^kvm.* ]]; then
>>   	if $qemu $M,\? | grep -q gic-version; then
>>   		M+=',gic-version=host'
>>   	fi
>>   fi
>>   
>> -if [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ]; then
>> +if [[ "$ACCEL" =~ ^kvm.* ]] || [[ "$ACCEL" =~ ^hvf.* ]]; then
>>   	if [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ]; then
>>   		processor="host"
>>   		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
>> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
>> index 51e4b97..e20b965 100644
>> --- a/scripts/arch-run.bash
>> +++ b/scripts/arch-run.bash
>> @@ -412,11 +412,11 @@ hvf_available ()
>>   
>>   get_qemu_accelerator ()
>>   {
>> -	if [ "$ACCEL" = "kvm" ] && ! kvm_available; then
>> +	if [[ "$ACCEL" =~ ^kvm.* ]] && [[ ! kvm_available ]]; then
>>   		echo "KVM is needed, but not available on this host" >&2
>>   		return 2
>>   	fi
>> -	if [ "$ACCEL" = "hvf" ] && ! hvf_available; then
>> +	if [[ "$ACCEL" =~ ^hvf.* ]] && [[ ! hvf_available ]]; then
>>   		echo "HVF is needed, but not available on this host" >&2
>>   		return 2
>>   	fi
>> -- 
> 
> I'd prefer that when we want to match 'kvm', 'tcg', etc. that we split
> on the first comma, rather than use a regular expression that allows
> arbitrary characters to follow the pattern. Actually
> get_qemu_accelerator() could do the splitting itself, providing two
> variables, ACCEL (only kvm, tcg, etc.) and ACCEL_PROPS (which is
> either null or has a leading comma). Then command lines just need
> to use $ACCEL$ACCEL_PROPS. If we do that, then get_qemu_accelerator()
> should also allow the user to pre-split, i.e.
> 
>    ACCEL=kvm ACCEL_PROPS=dirty-ring-size=65536 arm/run ...
> 
> Finally, did you also test this with the accel property in the
> unittests.cfg file run with run_tests.sh?
> 

Thanks for your quick comments. I think we can be smart to split
$ACCEL in get_qemu_accelarator() into $ACCEL and $ACCEL_PROPS if you
agree. It's not free to maintain another user visible property for
$ACCEL_PROPS.

I forgot to run "./runtest.sh" to make sure nothing is broken. I will
do this before v2 is posted. Note that v2 will be posted shortly :)

Thanks,
Gavin




