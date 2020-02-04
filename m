Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9522151A08
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 12:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgBDLld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 06:41:33 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29504 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727004AbgBDLld (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 06:41:33 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 014BbOdr085022
        for <kvm@vger.kernel.org>; Tue, 4 Feb 2020 06:41:32 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxtbjmhhg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 06:41:32 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Tue, 4 Feb 2020 11:41:29 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 4 Feb 2020 11:41:26 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 014BfPPH60227762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Feb 2020 11:41:25 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15B074C046;
        Tue,  4 Feb 2020 11:41:25 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C645F4C04A;
        Tue,  4 Feb 2020 11:41:24 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.108])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 Feb 2020 11:41:24 +0000 (GMT)
Date:   Tue, 4 Feb 2020 12:41:23 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 06/37] s390: add (non)secure page access exceptions
 handlers
In-Reply-To: <dd3d333d-d141-5a22-9b1d-161232b37cfb@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-7-borntraeger@de.ibm.com>
        <dd3d333d-d141-5a22-9b1d-161232b37cfb@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20020411-0020-0000-0000-000003A6DCEC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020411-0021-0000-0000-000021FEA237
Message-Id: <20200204124123.183ef25b@p-imbrenda>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-04_02:2020-02-04,2020-02-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 spamscore=0 phishscore=0 clxscore=1015 mlxscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002040082
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Feb 2020 11:37:42 +0100
Thomas Huth <thuth@redhat.com> wrote:

[...]

> > ---
> >  arch/s390/kernel/pgm_check.S |  4 +-
> >  arch/s390/mm/fault.c         | 87
> > ++++++++++++++++++++++++++++++++++++ 2 files changed, 89
> > insertions(+), 2 deletions(-)  
> [...]
> > +void do_non_secure_storage_access(struct pt_regs *regs)
> > +{
> > +	unsigned long gaddr = regs->int_parm_long &
> > __FAIL_ADDR_MASK;
> > +	struct gmap *gmap = (struct gmap *)S390_lowcore.gmap;
> > +	struct uv_cb_cts uvcb = {
> > +		.header.cmd = UVC_CMD_CONV_TO_SEC_STOR,
> > +		.header.len = sizeof(uvcb),
> > +		.guest_handle = gmap->se_handle,
> > +		.gaddr = gaddr,
> > +	};
> > +	int rc;
> > +
> > +	if (get_fault_type(regs) != GMAP_FAULT) {
> > +		do_fault_error(regs, VM_READ | VM_WRITE,
> > VM_FAULT_BADMAP);
> > +		WARN_ON_ONCE(1);
> > +		return;
> > +	}
> > +
> > +	rc = uv_make_secure(gmap, gaddr, &uvcb, 0);
> > +	if (rc == -EINVAL && uvcb.header.rc != 0x104)
> > +		send_sig(SIGSEGV, current, 0);
> > +}  
> 
> What about the other rc beside 0x104 that could happen here? They go
> unnoticed?

no, they are handled in the uv_make_secure, and return an appropriate
error code. 104 in this context still indicates that things were already
how we wanted, so we consider it a success here. e.g. for unpack it is
not considered a success. that's why we check for -EINVAL (which is the
generic error) and then check for the specific rc


a cleaner solution perhaps would have been to split uv_make_secure to
handle rc 0x104 differently, but I didn't want to duplicate the code
here.


Claudio


