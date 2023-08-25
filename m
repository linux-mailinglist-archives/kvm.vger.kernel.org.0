Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E684A787E1F
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 04:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbjHYC4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 22:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236143AbjHYC4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 22:56:45 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE39E78;
        Thu, 24 Aug 2023 19:56:43 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37P2UqhG002614;
        Fri, 25 Aug 2023 02:56:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=I54OJKkbfBa18QgwkudA0v/Jsp2IQaUta6yozDU1STw=;
 b=hCe+ym9qHyvgHZy+mE+w1h7nzCPeVsVVMeE6I0F/Wzh2n1hovFPuJ1GoIYsY0iGG/ddU
 oivDW4yTOCmavQvVL4OGV7YUSsRlqYXF9puLRKqkixqWtzP1IGGgkX1nafJNM+/lc6oe
 SKD4kR6D4qwVXpFRjaU7NMhXYH4N2GMolfREPvi8wnnOayVOyohiUBKhJGUo4rORiWVP
 yuOSpzVssqsH9yDtva7XOHUNjYRHvW6gSlUF+IxyDYyu4SufrmCX7u77MBH6gqJXb/AB
 5P5CUc0L3/kVqBgixIYfzrFyd/x38RaueTkNlGdocc1F7I9L/3ZCtJY5nwCnnhAe5Dpw KA== 
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3spkk68jqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Aug 2023 02:56:41 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37P2qYi9016727;
        Fri, 25 Aug 2023 02:56:41 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sn228496k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Aug 2023 02:56:41 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
        by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37P2uedl66322744
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 02:56:40 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E8C858059;
        Fri, 25 Aug 2023 02:56:40 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 594925804B;
        Fri, 25 Aug 2023 02:56:39 +0000 (GMT)
Received: from [9.61.160.138] (unknown [9.61.160.138])
        by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 25 Aug 2023 02:56:39 +0000 (GMT)
Message-ID: <0ddf808c-e929-c975-1b39-5ebc1f2fab62@linux.ibm.com>
Date:   Thu, 24 Aug 2023 22:56:38 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2] KVM: s390: fix gisa destroy operation might lead to
 cpu stalls
Content-Language: en-US
To:     Michael Mueller <mimu@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
References: <20230824130932.3573866-1-mimu@linux.ibm.com>
 <f20a40b8-2d7d-2fc5-33eb-ec0273e09308@linux.ibm.com>
 <a0f4dc8d-a649-3737-df46-c6ce3c1a26dd@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <a0f4dc8d-a649-3737-df46-c6ce3c1a26dd@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6SUk2ema7P2nML3beCHLeBwGivHmLj8u
X-Proofpoint-ORIG-GUID: 6SUk2ema7P2nML3beCHLeBwGivHmLj8u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-25_01,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308250017
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/24/23 4:36 PM, Michael Mueller wrote:
> 
> 
> On 24.08.23 21:17, Matthew Rosato wrote:
>> On 8/24/23 9:09 AM, Michael Mueller wrote:
>>> A GISA cannot be destroyed as long it is linked in the GIB alert list
>>> as this would breake the alert list. Just waiting for its removal from
>>
>> Hi Michael,
>>
>> Nit: s/breake/break/
>>
>>> the list triggered by another vm is not sufficient as it might be the
>>> only vm. The below shown cpu stall situation might occur when GIB alerts
>>> are delayed and is fixed by calling process_gib_alert_list() instead of
>>> waiting.
>>>
>>> At this time the vcpus of the vm are already destroyed and thus
>>> no vcpu can be kicked to enter the SIE again if for some reason an
>>> interrupt is pending for that vm.
>>>
>>> Additianally the IAM restore value ist set to 0x00 if that was not the
>>
>> Nits: s/Additianally/Additionally/  as well as s/ist/is/
>>
> 
> Thanks a lot, Matt. I will address of course all these typos ;)
> 
>>> case. That would be a bug introduced by incomplete device de-registration,
>>> i.e. missing kvm_s390_gisc_unregister() call.
>> If this implies a bug, maybe it should be a WARN_ON instead of a KVM_EVENT?  Because if we missed a call to kvm_s390_gisc_unregister() then we're also leaking refcounts (one for each gisc that we didn't unregister).
> 
> I was thinking of a WARN_ON() as well and will most probaly add it because it is much better visible.
> 
>>
>>>
>>> Setting this value guarantees that late interrupts don't bring the GISA
>>> back into the alert list.
>>
>> Just to make sure I understand -- The idea is that once you set the alert mask to 0x00 then it should be impossible for millicode to deliver further alerts associated with this gisa right?  Thus making it OK to do one last process_gib_alert_list() after that point in time.
>>
>> But I guess my question is: will millicode actually see this gi->alert.mask change soon enough to prevent further alerts?  Don't you need to also cmpxchg the mask update into the contents of kvm_s390_gisa (via gisa_set_iam?) 
> 
> It is not the IAM directly that I set to 0x00 but gi->alert.mask. It is used the restore the IAM in the gisa by means of gisa_get_ipm_or_restore_iam() under cmpxchg() conditions which is called by process_gib_alert_list() and the hr_timer function gisa_vcpu_kicker() that it triggers. When the gisa is in the alert list, the IAM is always 0x00. It's set by millicode. I just need to ensure that it is not changed to anything else.

Besides zeroing it while on the alert list and restoring the IAM to re-enable millicode alerts, we also change the IAM to enable a gisc (kvm_s390_gisc_register) and disable a gisc (kvm_s390_gisc_register) for alerts via a call to gisa_set_iam().  AFAIU the IAM is telling millicode what giscs host alerts should happen for, and the point of the gisa_set_iam() call during gisc_unregister is to tell millicode to stop alerts from being delivered for that gisc at that point.

Now for this patch, my understanding is that you are basically cleaning up after a driver that did not handle their gisc refcounts properly, right?  Otherwise by the time you reach gisa_destroy the alert.mask would already be 0x00.  Then in that case, wouldn't you want to force the unregistration of any gisc still in the IAM at gisa_destroy time -- meaning shouldn't we do the equivalent gisa_set_iam that would have previously been done during gisc_unregister, had it been called properly? 

For example, rather than just setting gi->alert.mask = 0x00 in kvm_s390_gisa_destroy(), what if you instead did:
1) issue the warning that gi->alert.mask was nonzero upon entry to gisa_destroy
2) perform the equivalent of calling kvm_s390_gisc_unregister() for every bit that is still on in the gi->alert.mask, performing the same actions as though the refcount were reaching 0 for each gisc (remove the bit from the alert mask, call gisa_set_iam).
3) Finally, process the alert list one more time if gisa_in_alert_list(gi->origin).  At this point, since we already set IAM to 0x00, millicode would have no further reason to deliver more alerts, so doing one last check should be safe.

That would be the same chain of events (minus the warning) that would occur if a driver actually called kvm_s390_gisc_unregister() the correct number of times.  Of course you could also just collapse step #2 -- doing that gets us _very_ close to this patch; you could just set gi->alert.mask directly to 0x00 like you do here but then you would also need a gisa_set_iam call to tell millicode to stop sending alerts for all of the giscs you just removed from the alert.mask.  In either approach, the -EBUSY return from gisa_set_iam would be an issue that needs to be handled.

Overall I guess until the IAM visible to millicode is set to 0x00 I'm not sure I understand what would prevent millicode from delivering another alert to any gisc still enabled in the IAM.  You say above it will be cmpxchg()'d during process_gib_alert_list() via gisa_get_ipm_or_restore_iam() but if we first check gisa_in_alert_list(gi->origin) with this new patch and the gisa is not yet in the alert list then we would skip the call to process_gib_alert_list() and instead just cancel the timer -- I could very well be misunderstanding something, but my concern is that you are shrinking but not eliminating the window here.  Let me try an example -- With this patch, isn't the following chain of events still possible:

1) enter kvm_s390_gisa_destroy.  Let's say gi->alert.mask = 0x80.
2) set gi->alert.mask = 0x00
3) check if(gisa_in_alert_list(gi->origin)) -- it returns false
4) Since the IAM still had a bit on at this point, millicode now delivers an alert for the gisc associated with bit 0x80 and sets IAM to 0x00 to indicate the gisa in the alert list
5) call hrtimer_cancel (since we already checked gisa_in_alert_list, we don't notice that last alert delivered)
6) set gi->origin = NULL, return from kvm_s390_gisa_destroy

Assuming that series of events is possible, wouldn't a solution be to replace step #3 above with something along the lines of this (untested diff on top of this patch):

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 06890a58d001..ab99c9ec1282 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -3220,6 +3220,10 @@ void kvm_s390_gisa_destroy(struct kvm *kvm)
                KVM_EVENT(3, "vm 0x%pK has unexpected restore iam 0x%02x",
                          kvm, gi->alert.mask);
                gi->alert.mask = 0x00;
+               while (gisa_set_iam(gi->origin, gi->alert.mask)) {
+                       KVM_EVENT(3, "vm 0x%pK alert while clearing iam", kvm);
+                       process_gib_alert_list();
+               }
        }
        if (gisa_in_alert_list(gi->origin)) {
                KVM_EVENT(3, "vm 0x%pK gisa in alert list during destroy", kvm);

> 
> in order to ensure an alert can't still be delivered some time after you check gisa_in_alert_list(gi->origin)?  That matches up with what is done per-gisc in kvm_s390_gisc_unregister() today.
> 
> right
> 
>>
>> ...  That said, now that I'm looking closer at kvm_s390_gisc_unregister() and gisa_set_iam():  it seems strange that nobody checks the return code from gisa_set_iam today.  AFAICT, even if the device driver(s) call kvm_s390_gisc_unregister correctly for all associated gisc, if gisa_set_iam manages to return -EBUSY because the gisa is already in the alert list then wouldn't the gisc refcounts be decremented but the relevant alert bit left enabled for that gisc until the next time we call gisa_set_iam or gisa_get_ipm_or_restore_iam?
> 
> you are right, that should retried in kvm_s390_gisc_register() and kvm_s390_gisc_unregister() until the rc is 0 but that would lead to a CPU stall as well under the condition where GAL interrupts are not delivered in the host.
> 
>>
>> Similar strangeness for kvm_s390_gisc_register() - AFAICT if gisa_set_iam returns -EBUSY then we would increment the gisc refcounts but never actually enable the alert bit for that gisc until the next time we call gisa_set_iam or gisa_get_ipm_or_restore_iam.
> 
> I have to think and play around with process_gib_alert_list() being called as well in these situations.
> 
> BTW the pci and the vfip_ap device drivers currently also ignore the return codes of kvm_s390_gisc_unregister().
> 

Hmm, good point.  You're right, we should probably do something there.  I think the 3 reasons kvm_s390_gisc_unregister() could give a nonzero RC today would all be strange, likely implementation bugs...

-ENODEV we also would have never been able to register, or something odd happened to gisa after registration
-ERANGE we also would have never been able to register, or the gisc got clobbered sometime after registration
-EINVAL either we never registered, unregistered too many times or gisa was destroyed on us somehow

I think for these cases the best pci/ap can do would be to WARN_ON(_ONCE) and then proceed just assuming that the gisc was unregistered or never properly registered.

Thanks,
Matt
