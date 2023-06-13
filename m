Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBFB572E24F
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 13:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242401AbjFMLzY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 07:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242235AbjFMLyv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 07:54:51 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3617BA;
        Tue, 13 Jun 2023 04:54:50 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35DBmB0W012853;
        Tue, 13 Jun 2023 11:54:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=GiFIPyq+2hexTE3/oEDa3HqeBg/NcZPM2EHbEjN2pvk=;
 b=m5IioPstzesaM+JDo97VaUdn0EtkeERF8uJdCkcQTjf3lk677T3Q+dFUBXx9Ag8P7vpX
 u93C/boB1VY0MyyI98tagGH/fh4wLcO3A7NESL9xLJnrhVEvwEfPQHJzZcRMDLWG29ys
 JIrrCTib+phLTJw7DCMfRq4OuF83vexaFihvSxOsdnrct6obbpPFUYTnrHZASpst3UgI
 lLrcsav6WvQIGbDVOBSnaKpwgAKkn7KqnrTrikl8AXtcZAkb11gfO3i/Sn5waN1xXL7f
 yosZAsSkvxWxKoZyhJ6gdnntw39hYL+jClfaDQDHCOmgK7I47prmJsNeCnKGf7GRA3Sg dQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r6qw084au-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Jun 2023 11:54:49 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35DBsndf004311;
        Tue, 13 Jun 2023 11:54:49 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r6qw084aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Jun 2023 11:54:49 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35D7xHvL031137;
        Tue, 13 Jun 2023 11:54:47 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3r4gt4sjja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Jun 2023 11:54:47 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35DBsiJK29622840
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jun 2023 11:54:44 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D74020043;
        Tue, 13 Jun 2023 11:54:44 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BF682004B;
        Tue, 13 Jun 2023 11:54:44 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 13 Jun 2023 11:54:43 +0000 (GMT)
Date:   Tue, 13 Jun 2023 13:54:42 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     borntraeger@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1] KVM: s390: selftests: CMMA: don't run if CMMA not
 supported
Message-ID: <20230613135442.67d7c5f4@p-imbrenda>
In-Reply-To: <20230606150510.671301-1-nrb@linux.ibm.com>
References: <20230606150510.671301-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: L0CSK0stJ7Y1zZrUFQM9lQMBt9VIQvkA
X-Proofpoint-GUID: e-9-KZP2m-zR3ABze8WkXYwH6AENpojc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-13_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0 spamscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2306130102
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  6 Jun 2023 17:05:10 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> The test at hand queried whether the kernel supports CMMA, but in
> addition machine support is required.
> 
> Add a check whether the machine supports CMMA.
> 
> This fixes the test under G3 (z/VM, KVM).
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  tools/testing/selftests/kvm/s390x/cmma_test.c | 20 +++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/s390x/cmma_test.c b/tools/testing/selftests/kvm/s390x/cmma_test.c
> index 6d0751ea224b..1d73e78e8fa7 100644
> --- a/tools/testing/selftests/kvm/s390x/cmma_test.c
> +++ b/tools/testing/selftests/kvm/s390x/cmma_test.c
> @@ -660,12 +660,32 @@ struct testdef {
>  	{ "GET_CMMA_BITS: holes are skipped", test_get_skip_holes },
>  };
>  
> +/**
> + * The kernel may support CMMA, but the machine may not (i.e. if running as
> + * guest-3).
> + *
> + * In this case, the CMMA capabilities are all there, but the CMMA-related
> + * ioctls fail. To find out whether the machine supports CMMA, create a
> + * temporary VM and then query the CMMA feature of the VM.
> + */
> +static int machine_has_cmma(void)
> +{
> +	struct kvm_vm *vm = create_vm();
> +	int r;
> +
> +	r = !__kvm_has_device_attr(vm->fd, KVM_S390_VM_MEM_CTRL, KVM_S390_VM_MEM_ENABLE_CMMA);
> +	kvm_vm_free(vm);
> +
> +	return r;
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	int idx;
>  
>  	TEST_REQUIRE(kvm_has_cap(KVM_CAP_SYNC_REGS));
>  	TEST_REQUIRE(kvm_has_cap(KVM_CAP_S390_CMMA_MIGRATION));
> +	TEST_REQUIRE(machine_has_cmma());
>  
>  	ksft_print_header();
>  

