Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8B4651A85
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 07:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbiLTGF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 01:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiLTGFZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 01:05:25 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA371BEC;
        Mon, 19 Dec 2022 22:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671516322; x=1703052322;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VUobp2ibXzyZTJ93NDEYKcJW/1VwPoOYbw9i716lO18=;
  b=Apjep1o4UZzDT1LNhi5ghPRcOPgMoGvwIE6667b8BJTkE2UTlWCOrziI
   hGSR2StpNrx/mMAEJ5OP9fxQs0fNMebdJ15dghKZD7iFTPVwXCSlimZ/Y
   nzFDd7wfZYorZBCi0KddBvM8/I0BpMQN0f7DNJi/wx/ra7RfYEE7E0TUR
   1expp5QOSAgLcoWtOJR2dUZ1rY14LRMPmEjUYgHRhlQImtKv5F6SRg/X6
   qSeFEdeH4Ml7M0mitFvVWwSWP6NU3I16wsfAA9DKVgWHNM5mP/7Ks23D5
   If+VADAMThCrOS7fWBVWghM+NToBFNdqo3Q1H56Uwbb3W5OtVUhi5sMnL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="319590547"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="319590547"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 22:05:22 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="825115698"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="825115698"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.174.63]) ([10.249.174.63])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 22:05:20 -0800
Message-ID: <1427f9d5-e9b8-80c1-541f-a83ff9ea0d91@linux.intel.com>
Date:   Tue, 20 Dec 2022 14:05:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] KVM: Destroy target device if coalesced MMIO
 unregistration fails
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?5p+z6I+B5bOw?= <liujingfeng@qianxin.com>
References: <20221219171924.67989-1-seanjc@google.com>
 <DS0PR11MB637301E9103F92EE5617D5B2DCEA9@DS0PR11MB6373.namprd11.prod.outlook.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <DS0PR11MB637301E9103F92EE5617D5B2DCEA9@DS0PR11MB6373.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/20/2022 11:04 AM, Wang, Wei W wrote:
> On Tuesday, December 20, 2022 1:19 AM, Sean Christopherson wrote:
>> diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c index
>> 0be80c213f7f..5ef88f5a0864 100644
>> --- a/virt/kvm/coalesced_mmio.c
>> +++ b/virt/kvm/coalesced_mmio.c
>> @@ -187,15 +187,17 @@ int
>> kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
>>   			r = kvm_io_bus_unregister_dev(kvm,
>>   				zone->pio ? KVM_PIO_BUS : KVM_MMIO_BUS, &dev->dev);
>>
>> +			kvm_iodevice_destructor(&dev->dev);
>> +
>>   			/*
>>   			 * On failure, unregister destroys all devices on the
>>   			 * bus _except_ the target device, i.e. coalesced_zones
>> -			 * has been modified.  No need to restart the walk as
>> -			 * there aren't any zones left.
>> +			 * has been modified.  Bail after destroying the target
>> +			 * device, there's no need to restart the walk as there
>> +			 * aren't any zones left.
>>   			 */
>>   			if (r)
>>   				break;
>> -			kvm_iodevice_destructor(&dev->dev);
>>   		}
>>   	}
> Another option is to let kvm_io_bus_unregister_dev handle this, and no need for callers
> to make the extra kvm_iodevice_destructor() call. This simplifies the usage for callers
> (e.g. reducing LOCs and no leakages like this):

One vote for this option : )


>
> diff --git a/include/kvm/iodev.h b/include/kvm/iodev.h
> index d75fc4365746..56619e33251e 100644
> --- a/include/kvm/iodev.h
> +++ b/include/kvm/iodev.h
> @@ -55,10 +55,4 @@ static inline int kvm_iodevice_write(struct kvm_vcpu *vcpu,
>                                   : -EOPNOTSUPP;
>   }
>
> -static inline void kvm_iodevice_destructor(struct kvm_io_device *dev)
> -{
> -       if (dev->ops->destructor)
> -               dev->ops->destructor(dev);
> -}
> -
>   #endif /* __KVM_IODEV_H__ */
> diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
> index 0be80c213f7f..d7135a5e76f8 100644
> --- a/virt/kvm/coalesced_mmio.c
> +++ b/virt/kvm/coalesced_mmio.c
> @@ -195,7 +195,6 @@ int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
>                           */
>                          if (r)
>                                  break;
> -                       kvm_iodevice_destructor(&dev->dev);
>                  }
>          }
>
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 2a3ed401ce46..1b277afb545b 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -898,7 +898,6 @@ kvm_deassign_ioeventfd_idx(struct kvm *kvm, enum kvm_bus bus_idx,
>                  bus = kvm_get_bus(kvm, bus_idx);
>                  if (bus)
>                          bus->ioeventfd_count--;
> -               ioeventfd_release(p);
>                  ret = 0;
>                  break;
>          }
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 13e88297f999..582757ebdce6 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5200,6 +5200,12 @@ static struct notifier_block kvm_reboot_notifier = {
>          .priority = 0,
>   };
>
> +static void kvm_iodevice_destructor(struct kvm_io_device *dev)
> +{
> +       if (dev->ops->destructor)
> +               dev->ops->destructor(dev);
> +}
> +
>   static void kvm_io_bus_destroy(struct kvm_io_bus *bus)
>   {
>          int i;
> @@ -5423,7 +5429,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
>   int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
>                                struct kvm_io_device *dev)
>   {
> -       int i, j;
> +       int i;
>          struct kvm_io_bus *new_bus, *bus;
>
>          lockdep_assert_held(&kvm->slots_lock);
> @@ -5453,18 +5459,18 @@ int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
>          rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
>          synchronize_srcu_expedited(&kvm->srcu);
>
> -       /* Destroy the old bus _after_ installing the (null) bus. */
> +       /*
> +        * If (null) bus is installed, destroy the old bus, including all the
> +        * attached devices. Otherwise, destroy the caller's device only.
> +        */
>          if (!new_bus) {
>                  pr_err("kvm: failed to shrink bus, removing it completely\n");
> -               for (j = 0; j < bus->dev_count; j++) {
> -                       if (j == i)
> -                               continue;
> -                       kvm_iodevice_destructor(bus->range[j].dev);
> -               }
> +               kvm_io_bus_destroy(bus);
> +               return -ENOMEM;
>          }
>
> -       kfree(bus);
> -       return new_bus ? 0 : -ENOMEM;
> +       kvm_iodevice_destructor(dev);
> +       return 0;
>   }
>
>   struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,
