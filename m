Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16CB94D67F2
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350880AbiCKRqf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350871AbiCKRqd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:46:33 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF7C1255B0;
        Fri, 11 Mar 2022 09:45:30 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22BFmhgi020965;
        Fri, 11 Mar 2022 17:45:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=FWB2Lt5dedQx/dMoHwE2pqnrUKCcWJjYrC3scYSx+NE=;
 b=SpXH2c81qCfI5oLVdZsjuihagGba2ni0EqufETB6AlSou6y8xpEqYE0c/A4jozU0yVZJ
 eYCUOiIjBREyfeJZ+D/SFEpXeSjuKhvb7QCN6/wYLnpV8gbktdw44YLNIQZ8YL6J+jz5
 x+Z17pYa1ZfRPSWtjTPADsN9Ni99Au0k6f4fyuydgMZ+iLrPw26cKuEdGqSCehTi3qng
 DN5UNv+CiiHy4aMtXJGXkGgWSed2TdAxcRSIZ1BwQJzZkelZc3/wccy4Q7Djnqpmixnu
 kKV6gbSx/ZBex+tLZoKmy4tkaHMD8HXPqg9wYxY/5AX2r8GqEJIpNL+vyiFqKF29ZwpM wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eqs92bw9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:45:29 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22BGbw2k023064;
        Fri, 11 Mar 2022 17:45:29 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eqs92bw95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:45:29 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22BHhtMb003380;
        Fri, 11 Mar 2022 17:45:27 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3ekyg8nc92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:45:27 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22BHjOpS22544744
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 17:45:24 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93E4A11C052;
        Fri, 11 Mar 2022 17:45:23 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41B5D11C04A;
        Fri, 11 Mar 2022 17:45:23 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.106])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Mar 2022 17:45:23 +0000 (GMT)
Date:   Fri, 11 Mar 2022 18:44:50 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH v2 5/9] KVM: s390: pv: Add query dump information
Message-ID: <20220311184450.51cc9ace@p-imbrenda>
In-Reply-To: <20220310103112.2156-6-frankja@linux.ibm.com>
References: <20220310103112.2156-1-frankja@linux.ibm.com>
        <20220310103112.2156-6-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: anBpojp5oreilRyvlSr7EzpspybOfSOk
X-Proofpoint-ORIG-GUID: 8zRDZvsi2I4jtk-J1vbO-4OA3ucjvyIn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-11_07,2022-03-11_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 adultscore=0 clxscore=1015 mlxlogscore=999 spamscore=0
 mlxscore=0 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203110085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Mar 2022 10:31:08 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The dump API requires userspace to provide buffers into which we will
> store data. The dump information added in this patch tells userspace
> how big those buffers need to be.

it seems this has the same issue as the other patch.

if userspace gives a smaller buffer, as much data as possible should be
written into it

> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 11 +++++++++++
>  include/uapi/linux/kvm.h | 12 +++++++++++-
>  2 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 67e1e445681f..c388d08b9626 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2255,6 +2255,17 @@ static ssize_t kvm_s390_handle_pv_info(struct kvm_s390_pv_info *info)
>  
>  		return len;
>  	}
> +	case KVM_PV_INFO_DUMP: {
> +		len =  sizeof(info->header) + sizeof(info->dump);
> +
> +		if (info->header.len_max < len)
> +			return -EINVAL;
> +
> +		info->dump.dump_cpu_buffer_len = uv_info.guest_cpu_stor_len;
> +		info->dump.dump_config_mem_buffer_per_1m = uv_info.conf_dump_storage_state_len;
> +		info->dump.dump_config_finalize_len = uv_info.conf_dump_finalize_len;
> +		return len;
> +	}
>  	default:
>  		return -EINVAL;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 21f19863c417..eed2ae8397ae 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1645,6 +1645,13 @@ struct kvm_s390_pv_unp {
>  
>  enum pv_cmd_info_id {
>  	KVM_PV_INFO_VM,
> +	KVM_PV_INFO_DUMP,
> +};
> +
> +struct kvm_s390_pv_info_dump {
> +	__u64 dump_cpu_buffer_len;
> +	__u64 dump_config_mem_buffer_per_1m;
> +	__u64 dump_config_finalize_len;
>  };
>  
>  struct kvm_s390_pv_info_vm {
> @@ -1664,7 +1671,10 @@ struct kvm_s390_pv_info_header {
>  
>  struct kvm_s390_pv_info {
>  	struct kvm_s390_pv_info_header header;
> -	struct kvm_s390_pv_info_vm vm;
> +	union {
> +		struct kvm_s390_pv_info_dump dump;
> +		struct kvm_s390_pv_info_vm vm;
> +	};
>  };
>  
>  enum pv_cmd_id {

