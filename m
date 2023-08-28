Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 525BB78AC6A
	for <lists+kvm@lfdr.de>; Mon, 28 Aug 2023 12:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbjH1Kj4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Aug 2023 06:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbjH1Kjb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Aug 2023 06:39:31 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F82393;
        Mon, 28 Aug 2023 03:39:28 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37S9c9iB018834;
        Mon, 28 Aug 2023 10:39:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2Trs+Gigq2wmY4pNmTj0HY0wQXTsqXgcJq1rLw9sNtM=;
 b=Db8YhJD+0ok7oolbDjTVl/gPKCUI3549pEKM3TKQacefINqtkuM5pgKWqbgwo6Dn6Z+P
 hyrwtSLMTw+Ghi955JfDouz46CUSn3pd8ONiilDCYCMQQA5cwyjITuJGLJdp55sLxrGv
 Wc1bxGQ5Tcn9ug2Ry6KBW0eCUBVJ0ZMdqdRn9xepJTlIFQx4DV4uasSopvH5qt1y0FQh
 RzqnDs7u02vrPMbewNpgABuih1w1L2o+3w/cuV+kTn6HyUaDhz8IRPpo/4vaYRVLIj7K
 5Yd7/AwPy5p0+vw0b7liviMcU5Eg1gz0VOE7gjG11tNhnrzfJZvQnxxBupo0CNkRKJYM ug== 
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sr87gtaj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Aug 2023 10:39:27 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37S8xSCE019171;
        Mon, 28 Aug 2023 10:39:26 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3sqxe19cmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Aug 2023 10:39:26 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37SAdNqY61735394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Aug 2023 10:39:23 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C63A2006A;
        Mon, 28 Aug 2023 10:39:19 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59D222004B;
        Mon, 28 Aug 2023 10:39:18 +0000 (GMT)
Received: from [9.179.5.186] (unknown [9.179.5.186])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 28 Aug 2023 10:39:18 +0000 (GMT)
Message-ID: <fa4e2086-8d7c-84dc-8c35-5d9ea1bfda3c@linux.ibm.com>
Date:   Mon, 28 Aug 2023 12:39:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v2] KVM: s390: fix gisa destroy operation might lead to
 cpu stalls
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20230824130932.3573866-1-mimu@linux.ibm.com>
 <f20a40b8-2d7d-2fc5-33eb-ec0273e09308@linux.ibm.com>
 <a0f4dc8d-a649-3737-df46-c6ce3c1a26dd@linux.ibm.com>
 <0ddf808c-e929-c975-1b39-5ebc1f2fab62@linux.ibm.com>
From:   Michael Mueller <mimu@linux.ibm.com>
In-Reply-To: <0ddf808c-e929-c975-1b39-5ebc1f2fab62@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: r3dWZCcuNDDuSN7FBGYhEVMb85IOYig5
X-Proofpoint-GUID: r3dWZCcuNDDuSN7FBGYhEVMb85IOYig5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-28_07,2023-08-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 impostorscore=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 phishscore=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2308100000 definitions=main-2308280095
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 25.08.23 04:56, Matthew Rosato wrote:
> On 8/24/23 4:36 PM, Michael Mueller wrote:
>>
>>
>> On 24.08.23 21:17, Matthew Rosato wrote:
>>> On 8/24/23 9:09 AM, Michael Mueller wrote:
>>>> A GISA cannot be destroyed as long it is linked in the GIB alert list
>>>> as this would breake the alert list. Just waiting for its removal from
>>>
>>> Hi Michael,
>>>
>>> Nit: s/breake/break/
>>>
>>>> the list triggered by another vm is not sufficient as it might be the
>>>> only vm. The below shown cpu stall situation might occur when GIB alerts
>>>> are delayed and is fixed by calling process_gib_alert_list() instead of
>>>> waiting.
>>>>
>>>> At this time the vcpus of the vm are already destroyed and thus
>>>> no vcpu can be kicked to enter the SIE again if for some reason an
>>>> interrupt is pending for that vm.
>>>>
>>>> Additianally the IAM restore value ist set to 0x00 if that was not the
>>>
>>> Nits: s/Additianally/Additionally/  as well as s/ist/is/
>>>
>>
>> Thanks a lot, Matt. I will address of course all these typos ;)
>>
>>>> case. That would be a bug introduced by incomplete device de-registration,
>>>> i.e. missing kvm_s390_gisc_unregister() call.
>>> If this implies a bug, maybe it should be a WARN_ON instead of a KVM_EVENT?  Because if we missed a call to kvm_s390_gisc_unregister() then we're also leaking refcounts (one for each gisc that we didn't unregister).
>>
>> I was thinking of a WARN_ON() as well and will most probaly add it because it is much better visible.
>>
>>>
>>>>
>>>> Setting this value guarantees that late interrupts don't bring the GISA
>>>> back into the alert list.
>>>
>>> Just to make sure I understand -- The idea is that once you set the alert mask to 0x00 then it should be impossible for millicode to deliver further alerts associated with this gisa right?  Thus making it OK to do one last process_gib_alert_list() after that point in time.
>>>
>>> But I guess my question is: will millicode actually see this gi->alert.mask change soon enough to prevent further alerts?  Don't you need to also cmpxchg the mask update into the contents of kvm_s390_gisa (via gisa_set_iam?)
>>
>> It is not the IAM directly that I set to 0x00 but gi->alert.mask. It is used the restore the IAM in the gisa by means of gisa_get_ipm_or_restore_iam() under cmpxchg() conditions which is called by process_gib_alert_list() and the hr_timer function gisa_vcpu_kicker() that it triggers. When the gisa is in the alert list, the IAM is always 0x00. It's set by millicode. I just need to ensure that it is not changed to anything else.
> 
> Besides zeroing it while on the alert list and restoring the IAM to re-enable millicode alerts, we also change the IAM to enable a gisc (kvm_s390_gisc_register) and disable a gisc (kvm_s390_gisc_register) for alerts via a call to gisa_set_iam().  AFAIU the IAM is telling millicode what giscs host alerts should happen for, and the point of the gisa_set_iam() call during gisc_unregister is to tell millicode to stop alerts from being delivered for that gisc at that point.

Yes, the kvm_s390_gisc_register() function manages the alert.mask to be 
restored into the IAM when a gisa is processed in the alert list as well 
as the IAM when a first/additinal guest ISC has to be handled, that's 
the case for a first/second AP or PCI adapter. In case it's the very 
first GISC, eg. AP_ISC, the gisa cannot be in the alert list, whence 
gisa_set_iam() will be successful. When a second AP_ISC is registered 
the alert.mask is not changed and thus gisa_set_iam() is NOT called. If 
a different guest ISC is registered, e.g. PCI_ISC, the alert.mask is 
updated and the gisa_set_iam() tries to set the new IAM. In case the 
gisa is in the alert list the gisa_set_iam() call returns -EBUSY but we 
don't need to care because the correct IAM will be restored during the 
processsing of the alert list. I the gisa is not in the alert list the 
call will be successful and the new IAM is set.

The situation for kvm_s390_gisc_unregister() will be similar, let's walk 
through it. The gisa_set_iam() nees to be called always when the last of 
a specific guest ISCs is deregistered and also the alert.mask is 
changed. The condition is that ref_count[gisc] is decrease by 1 and 
becomes 0. Then the respective bit is cleared in the alert.mask and 
gisa_set_iam() tries to update the IAM. In case the gisa is in the alert 
list the IAM will be restored with the current alert.mask which has the 
bit already cleared. In case the gisa is not in the alert list the IAM 
will be set immediately.

> 
> Now for this patch, my understanding is that you are basically cleaning up after a driver that did not handle their gisc refcounts properly, right?  Otherwise by the time you reach gisa_destroy the alert.mask would already be 0x00.  Then in that case, wouldn't you want to force the unregistration of any gisc still in the IAM at gisa_destroy time -- meaning shouldn't we do the equivalent gisa_set_iam that would have previously been done during gisc_unregister, had it been called properly?

The problem with the patch that I currently see is that it tries to 
solve two different bug scenaries that I have not sketched properly.

Yes, I want to do a cleanup a) for the situation that the alert.mask is 
NOT 0x00 during gisa destruction which is caused by a missing 
kvm_s390_gisc_unregister() and that's a bug.

And b) for the situation that a gisa is still in the alert list during 
gisa destruction. That happend due to a bug in this case as well. The 
patch from Benjamin in devel 88a096a7a460 accidently switched off the 
GAL interrupt processing in the host. Thus the 
kvm_s390_gisc_unregister() was called by the AP driver but the alert was 
not processed (and never could have processed). My code then ran into 
that endless loop which is a bug as well:

  while (gisa_in_alert_list(gi->origin))
    relax_cpu()

> 
> For example, rather than just setting gi->alert.mask = 0x00 in kvm_s390_gisa_destroy(), what if you instead did:
> 1) issue the warning that gi->alert.mask was nonzero upon entry to gisa_destroy
> 2) perform the equivalent of calling kvm_s390_gisc_unregister() for every bit that is still on in the gi->alert.mask, performing the same actions as though the refcount were reaching 0 for each gisc (remove the bit from the alert mask, call gisa_set_iam).
> 3) Finally, process the alert list one more time if gisa_in_alert_list(gi->origin).  At this point, since we already set IAM to 0x00, millicode would have no further reason to deliver more alerts, so doing one last check should be safe.

yes, that should work

> 
> That would be the same chain of events (minus the warning) that would occur if a driver actually called kvm_s390_gisc_unregister() the correct number of times.  Of course you could also just collapse step #2 -- doing that gets us _very_ close to this patch; you could just set gi->alert.mask directly to 0x00 like you do here but then you would also need a gisa_set_iam call to tell millicode to stop sending alerts for all of the giscs you just removed from the alert.mask.  In either approach, the -EBUSY return from gisa_set_iam would be an issue that needs to be handled.

The -EBUSY does not need a special treatment in this case because it 
means the gisa is in the alert list and no additional alerts for the 
same gisa are triggert by the millicode. Also not for other guest ISC 
bits. The IAM is cleared to 0x00 by millicode as well.

Either the gisa is not in the alert list, then the IAM was set to 0x00 
already by the previous gisa_set_iam() an cannot be brought back to the 
alert list by millicode or I call process_gib_alert_list() once when the 
gisa is in the alert list, then the IAM is 0x00 (set by millicaode) and 
will be restored to 0x00 by gisa_vcpu_kicker()/gisa_get_ipm_or_restore_iam()

I don't want to run process_gib_alert_list() unconditionally because it 
would touch other guest also even if not required.

I will send a v3 today.

Thanks a lot!

> 
> Overall I guess until the IAM visible to millicode is set to 0x00 I'm not sure I understand what would prevent millicode from delivering another alert to any gisc still enabled in the IAM.  You say above it will be cmpxchg()'d during process_gib_alert_list() via gisa_get_ipm_or_restore_iam() but if we first check gisa_in_alert_list(gi->origin) with this new patch and the gisa is not yet in the alert list then we would skip the call to process_gib_alert_list() and instead just cancel the timer -- I could very well be misunderstanding something, but my concern is that you are shrinking but not eliminating the window here.  Let me try an example -- With this patch, isn't the following chain of events still possible:
> 
> 1) enter kvm_s390_gisa_destroy.  Let's say gi->alert.mask = 0x80.
> 2) set gi->alert.mask = 0x00
> 3) check if(gisa_in_alert_list(gi->origin)) -- it returns false
> 4) Since the IAM still had a bit on at this point, millicode now delivers an alert for the gisc associated with bit 0x80 and sets IAM to 0x00 to indicate the gisa in the alert list
> 5) call hrtimer_cancel (since we already checked gisa_in_alert_list, we don't notice that last alert delivered)
> 6) set gi->origin = NULL, return from kvm_s390_gisa_destroy
> 
> Assuming that series of events is possible, wouldn't a solution be to replace step #3 above with something along the lines of this (untested diff on top of this patch):
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 06890a58d001..ab99c9ec1282 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -3220,6 +3220,10 @@ void kvm_s390_gisa_destroy(struct kvm *kvm)
>                  KVM_EVENT(3, "vm 0x%pK has unexpected restore iam 0x%02x",
>                            kvm, gi->alert.mask);
>                  gi->alert.mask = 0x00;
> +               while (gisa_set_iam(gi->origin, gi->alert.mask)) {
> +                       KVM_EVENT(3, "vm 0x%pK alert while clearing iam", kvm);
> +                       process_gib_alert_list();
> +               }
>          }
>          if (gisa_in_alert_list(gi->origin)) {
>                  KVM_EVENT(3, "vm 0x%pK gisa in alert list during destroy", kvm);
> 
>>
>> in order to ensure an alert can't still be delivered some time after you check gisa_in_alert_list(gi->origin)?  That matches up with what is done per-gisc in kvm_s390_gisc_unregister() today.
>>
>> right
>>
>>>
>>> ...  That said, now that I'm looking closer at kvm_s390_gisc_unregister() and gisa_set_iam():  it seems strange that nobody checks the return code from gisa_set_iam today.  AFAICT, even if the device driver(s) call kvm_s390_gisc_unregister correctly for all associated gisc, if gisa_set_iam manages to return -EBUSY because the gisa is already in the alert list then wouldn't the gisc refcounts be decremented but the relevant alert bit left enabled for that gisc until the next time we call gisa_set_iam or gisa_get_ipm_or_restore_iam?
>>
>> you are right, that should retried in kvm_s390_gisc_register() and kvm_s390_gisc_unregister() until the rc is 0 but that would lead to a CPU stall as well under the condition where GAL interrupts are not delivered in the host.
>>
>>>
>>> Similar strangeness for kvm_s390_gisc_register() - AFAICT if gisa_set_iam returns -EBUSY then we would increment the gisc refcounts but never actually enable the alert bit for that gisc until the next time we call gisa_set_iam or gisa_get_ipm_or_restore_iam.
>>
>> I have to think and play around with process_gib_alert_list() being called as well in these situations.
>>
>> BTW the pci and the vfip_ap device drivers currently also ignore the return codes of kvm_s390_gisc_unregister().
>>
> 
> Hmm, good point.  You're right, we should probably do something there.  I think the 3 reasons kvm_s390_gisc_unregister() could give a nonzero RC today would all be strange, likely implementation bugs...
> 
> -ENODEV we also would have never been able to register, or something odd happened to gisa after registration
> -ERANGE we also would have never been able to register, or the gisc got clobbered sometime after registration
> -EINVAL either we never registered, unregistered too many times or gisa was destroyed on us somehow
> 
> I think for these cases the best pci/ap can do would be to WARN_ON(_ONCE) and then proceed just assuming that the gisc was unregistered or never properly registered.
> 
> Thanks,
> Matt
