Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11D89667EE
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 09:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfGLHpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 03:45:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47032 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfGLHpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 03:45:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6C7i7f6178923;
        Fri, 12 Jul 2019 07:44:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=8T/t61hH+mxP53WzfTtGAJxdQjq9tmKdl9zDJcQJWT0=;
 b=5DX7PGyyiqAuHqdElQqOA4nGLmMdtiOKrdKtqVkBCGeRmC1rNLNWcBzr/XdK+h1EBtOE
 hQ+Q6neY2rtBbsU8vFeLSaXP+vl6vLk9dU25fu42tJrcGwfGOkPPySvBVMJSIQcoN8Ok
 xqMS2nf2qUM4tEKg1uD5x3Mk2k3EJ8DiF78j7sC1lIF9lBTUOrzSDX8B0kHKmnvxe5DJ
 PO1MVtehBbtIbtqHCPfUkI39iBsWtpMIDc5BuK5Nkt9DqRuyGdf3pBcbGmaK3w2zxAOd
 tPMNV8l2yuBlHrT0j3BPgSSzV2ri/NhdC80csgqE87Vlp1/u4WUCNR7Vf912WOzePgIJ Pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2tjk2u445s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 07:44:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6C7hXBw019439;
        Fri, 12 Jul 2019 07:44:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2tmwgympn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 07:44:06 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6C7i3Sq030229;
        Fri, 12 Jul 2019 07:44:04 GMT
Received: from [10.166.106.34] (/10.166.106.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Jul 2019 00:44:03 -0700
Subject: Re: [RFC v2 01/26] mm/x86: Introduce kernel address space isolation
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
 <1562855138-19507-2-git-send-email-alexandre.chartre@oracle.com>
 <alpine.DEB.2.21.1907112321570.1782@nanos.tec.linutronix.de>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Organization: Oracle Corporation
Message-ID: <42eac268-9b3a-b444-8288-76d57faf0826@oracle.com>
Date:   Fri, 12 Jul 2019 09:43:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1907112321570.1782@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907120080
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907120080
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/11/19 11:33 PM, Thomas Gleixner wrote:
> On Thu, 11 Jul 2019, Alexandre Chartre wrote:
>> +/*
>> + * When isolation is active, the address space doesn't necessarily map
>> + * the percpu offset value (this_cpu_off) which is used to get pointers
>> + * to percpu variables. So functions which can be invoked while isolation
>> + * is active shouldn't be getting pointers to percpu variables (i.e. with
>> + * get_cpu_var() or this_cpu_ptr()). Instead percpu variable should be
>> + * directly read or written to (i.e. with this_cpu_read() or
>> + * this_cpu_write()).
>> + */
>> +
>> +int asi_enter(struct asi *asi)
>> +{
>> +	enum asi_session_state state;
>> +	struct asi *current_asi;
>> +	struct asi_session *asi_session;
>> +
>> +	state = this_cpu_read(cpu_asi_session.state);
>> +	/*
>> +	 * We can re-enter isolation, but only with the same ASI (we don't
>> +	 * support nesting isolation). Also, if isolation is still active,
>> +	 * then we should be re-entering with the same task.
>> +	 */
>> +	if (state == ASI_SESSION_STATE_ACTIVE) {
>> +		current_asi = this_cpu_read(cpu_asi_session.asi);
>> +		if (current_asi != asi) {
>> +			WARN_ON(1);
>> +			return -EBUSY;
>> +		}
>> +		WARN_ON(this_cpu_read(cpu_asi_session.task) != current);
>> +		return 0;
>> +	}
>> +
>> +	/* isolation is not active so we can safely access the percpu pointer */
>> +	asi_session = &get_cpu_var(cpu_asi_session);
> 
> get_cpu_var()?? Where is the matching put_cpu_var() ? get_cpu_var()
> contains a preempt_disable ...
> 
> What's wrong with a simple this_cpu_ptr() here?
> 

Oups, my mistake, I should be using this_cpu_ptr(). I will replace all get_cpu_var()
with this_cpu_ptr().


>> +void asi_exit(struct asi *asi)
>> +{
>> +	struct asi_session *asi_session;
>> +	enum asi_session_state asi_state;
>> +	unsigned long original_cr3;
>> +
>> +	asi_state = this_cpu_read(cpu_asi_session.state);
>> +	if (asi_state == ASI_SESSION_STATE_INACTIVE)
>> +		return;
>> +
>> +	/* TODO: Kick sibling hyperthread before switching to kernel cr3 */
>> +	original_cr3 = this_cpu_read(cpu_asi_session.original_cr3);
>> +	if (original_cr3)
> 
> Why would this be 0 if the session is active?
> 

Correct, original_cr3 won't be 0. I think this is a remain from a previous version
where original_cr3 was handled differently.


>> +		write_cr3(original_cr3);
>> +
>> +	/* page-table was switched, we can now access the percpu pointer */
>> +	asi_session = &get_cpu_var(cpu_asi_session);
> 
> See above.
> 

Will fix that.


Thanks,

alex.

>> +	WARN_ON(asi_session->task != current);
>> +	asi_session->state = ASI_SESSION_STATE_INACTIVE;
>> +	asi_session->asi = NULL;
>> +	asi_session->task = NULL;
>> +	asi_session->original_cr3 = 0;
>> +}
> 
> Thanks,
> 
> 	tglx
> 
