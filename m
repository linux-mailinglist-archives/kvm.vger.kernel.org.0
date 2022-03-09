Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634604D256E
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 02:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbiCIBOT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 20:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbiCIBNV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 20:13:21 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C663158EA4;
        Tue,  8 Mar 2022 16:56:44 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2290uJh5032621;
        Wed, 9 Mar 2022 00:56:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=4aVxwyeD2G4aJ13Isb/s8+ZwAEF2AuWYkvaBomm/JKk=;
 b=kHgaffANgvHzTSZJ46ZtEWlnPxjbQ30eNnAcGmfXdZn5S6UxLYL6DPreoxyfVE627YA+
 3CpJnandNQOcLBbYEGCd7D7SzuD6+D5m/NnFLgQJBvjkvyGuKlH0MUkl6CHdsJOvzues
 iU8jN5ohP7/mb1MyGEg/R3j77nszf6eXoHGoz8/bqNklrJmUzztvtjEnu7iFle7ztjN/
 quenmZJ9JkMyrrh60m3uXT7gryH9TeaspDwKc1LOFfNaYEf6+cStM+yQEkL/7wpZoebm
 i3boAI6OgGgxMsQaoRTcNA7eaU8Z66nyqaex/uLfsVfkNH28JE3F4yeAsbPkxWbDfMa1 aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3enxs0fdkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Mar 2022 00:56:42 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2290ugoG005484;
        Wed, 9 Mar 2022 00:56:42 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3enxs0fdkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Mar 2022 00:56:42 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2290mRTX026754;
        Wed, 9 Mar 2022 00:56:39 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3ekyg90q5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Mar 2022 00:56:39 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2290jQRs50135422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Mar 2022 00:45:26 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48D38A4040;
        Wed,  9 Mar 2022 00:56:36 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98817A4051;
        Wed,  9 Mar 2022 00:56:35 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.68.74])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed,  9 Mar 2022 00:56:35 +0000 (GMT)
Date:   Wed, 9 Mar 2022 01:56:22 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     "Jason J. Herne" <jjherne@linux.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v18 08/18] s390/vfio-ap: allow assignment of unavailable
 AP queues to mdev device
Message-ID: <20220309015623.41543d75.pasic@linux.ibm.com>
In-Reply-To: <439f929f-9d15-c33c-b40d-88dd06cebd85@linux.ibm.com>
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
        <20220215005040.52697-9-akrowiak@linux.ibm.com>
        <97681738-50a1-976d-9f0f-be326eab7202@linux.ibm.com>
        <9ac3908e-06da-6276-d1df-94898918fc5b@linux.ibm.com>
        <439f929f-9d15-c33c-b40d-88dd06cebd85@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GA7MBmohm27r3Zs2kEBhAhj3DjFWk2M6
X-Proofpoint-ORIG-GUID: LKkedgjD1fvryOKywwrOlMlSNoswUhsZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-08_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 bulkscore=0 mlxlogscore=537 clxscore=1015 adultscore=0 spamscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203090000
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 8 Mar 2022 10:39:09 -0500
"Jason J. Herne" <jjherne@linux.ibm.com> wrote:

> On 3/7/22 07:31, Tony Krowiak wrote:
> >>> +         * If the input apm and aqm belong to the matrix_mdev's matrix,
> >>> +         * then move on to the next.
> >>> +         */
> >>> +        if (mdev_apm == matrix_mdev->matrix.apm &&
> >>> +            mdev_aqm == matrix_mdev->matrix.aqm)
> >>>               continue;  
> >>
> >> We may have a problem here. This check seems like it exists to stop you from
> >> comparing an mdev's apm/aqm with itself. Obviously comparing an mdev's newly
> >> updated apm/aqm with itself would cause a false positive sharing check, right?
> >> If this is the case, I think the comment should be changed to reflect that.  
> > 
> > You are correct, this check is performed to prevent comparing an mdev to
> > itself, I'll improve the comment.
> >   
> >>
> >> Aside from the comment, what stops this particular series of if statements from
> >> allowing us to configure a second mdev with the exact same apm/aqm values as an
> >> existing mdev? If we do, then this check's continue will short circuit the rest
> >> of the function thereby allowing that 2nd mdev even though it should be a
> >> sharing violation.  
> > 
> > I don't see how this is possible.  
> 
> You are correct. I missed the fact that you are comparing pointers here, and not
> values. Apologies. Now that I understand the code, I agree that this is fine as is.
> 

I believe clarifying the 'belongs to' vs 'is a part of' stuff is still
worthwhile, because 'belongs to' does beg the question you asked. Thus
IMHO it is good that you raised the question.

Regards,
Halil
