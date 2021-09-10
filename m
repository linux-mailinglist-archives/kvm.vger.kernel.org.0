Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D440C406D5E
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 16:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbhIJONu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 10:13:50 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:63862 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233783AbhIJONs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Sep 2021 10:13:48 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18ADwAan002711;
        Fri, 10 Sep 2021 14:12:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=WV84473mY/QnlTgy97iss3EhFP2pohKEB6q/EhCJiVQ=;
 b=yZO7j8v/IKSbu7v48sw/noynz0OhwGahv9YJMtYPpJuGJ4GVr959gOstz20+fFr8YP4G
 W0R3uK2urAryEGkkZiS7CQBLSg45YPZW10xJPPLuwfkIg7IUXsHhBMvoeu3X5xty7251
 twr9+jhGzRcMpfzjUCFJ75H8/+ESBGzsRLy6ssT+CEDKKa+9WeWFLVNJ3gBUiOd8XnZT
 /VAODwSkesEX/53s1OmgzMXUNecgdBj8Z1IhQjkQoj62yY3KR2sAdBNrhZnG4JyFZYLC
 rHHQaZlYGUH/H5rspomZb4OpQOVDk4uvMgUEv6yq67UOMIMPizIogvjsNLqAexTGMSTy jg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=WV84473mY/QnlTgy97iss3EhFP2pohKEB6q/EhCJiVQ=;
 b=lHd9y7DP4s12II9nfkL0owfM1tD6c6eOBcmyBBgmVKGp5OED4dGffZ79ma+DjA/IVzQr
 CLHnIs7vpH9ti213wPuNSWcw3G3ELfWKDEzzieV6toi8LQMXLx0mJb5WwWdMb8PaXZm6
 smiTtTvPasNsHJAlGgCAglAS0lGoA0MBWOMndKVkN/e7o/pEQ9MaO+Hj4FAxIhDYJ2P+
 16DbPSKeRxe0LCUk/MAU2HhMR8ScqN6hbDjCmgBRRkN+jV1o2RWDnxUsNC8FArz05tHp
 EUONTYOSO7LIEcOgToSkUybh6oQIfneyybIUcl/bqksOZmnYpyaGGWaz+WLWPXt+923F ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aytx4t0ye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 14:12:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18AE6CAi095051;
        Fri, 10 Sep 2021 14:12:30 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3020.oracle.com with ESMTP id 3aytfycdn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 14:12:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9Ft2BsQbc2G42hQXblVrWkvmTG+GiY3bcN6/TcIhNP9xJVZ9uth8TbFpaE64EMTQTNLpmf+Le/m66d2X2hMuqr/Oya6XQDUhk0Us/59Mfj74ZnXGIFJSSB0NUqjqwI5Hv8rjPyd/pprsTjme7utGNTZB0/TUYwJ7vIKKO3SHLKVnE5XQHvnJjusSGSHfUSCbrcWHmYjVGjBXEx+rnaML5AaUBhZUmRStXfRX2SFk7+Uqm0C8NbviMRje+VQ5lVH48T01lDZENYMmPMiQo6Y87+DZVVMEVAGZp0+jnrtoGJZwwMZbP+7IK457s17nASHHMu1LhYxKXg+dCvzNV1gHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=WV84473mY/QnlTgy97iss3EhFP2pohKEB6q/EhCJiVQ=;
 b=RgE8YeMODyswEVRO15w9i5RVpDEHbBgEEnuqM8T6Lf2hl9iHjC4jTH9GmlYhsiWUx4qiu8oqbqqan+tfRhyn/hHS+Ufff2esa9sJ4Rs4bEEiXmWxy+wL8LWLI+sYd+wXU7fLUxkTRP0YjbTSQkrD7F4DFJRBYFNlOXey+M+Djyy5ECWIKDknJ2vFIv89m9DTx1f5Zbp7mjO/MCQQOUKqp3B7xiMclKgrk5aQBIJB+doIpJ9ctN/tWJa8Xu7vsoNla9HhY3UdjZpuqVx5N5T+S4OQOH67rZFSx6ETXofiSm+qMtqDGD9qJVHBRIyi2gefcwo3IRX03LMuje1mSUN3aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WV84473mY/QnlTgy97iss3EhFP2pohKEB6q/EhCJiVQ=;
 b=XzdOsdXdtqHiXX7TyH7nQG8lxxqWHDWYbpNvpGnRc45lPBf+TB7RcntYjS7ZdzamKSTeiwcnfk5MRd3gLGCBQBCrD5HFsVOv/ylp+iQ7ATnp6sGB3nI6viO54y7+eYhMD7S/TkpyZLHWIlVK7gsudMsF6WJBtU3aUjQ5dQG5UjU=
Received: from DM6PR10MB4380.namprd10.prod.outlook.com (2603:10b6:5:223::19)
 by DM6PR10MB3337.namprd10.prod.outlook.com (2603:10b6:5:1ad::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Fri, 10 Sep
 2021 14:12:29 +0000
Received: from DM6PR10MB4380.namprd10.prod.outlook.com
 ([fe80::f4b1:d890:7745:30a3]) by DM6PR10MB4380.namprd10.prod.outlook.com
 ([fe80::f4b1:d890:7745:30a3%5]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 14:12:29 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     David Hildenbrand <david@redhat.com>
CC:     Niklas Schnelle <schnelle@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH RFC 6/9] s390/pci_mmio: fully validate the VMA before
 calling follow_pte()
Thread-Topic: [PATCH RFC 6/9] s390/pci_mmio: fully validate the VMA before
 calling follow_pte()
Thread-Index: AQHXpYt94rWRlMpIgEO//XQ8blRXe6uc7v8AgAARCACAAFCfgA==
Date:   Fri, 10 Sep 2021 14:12:28 +0000
Message-ID: <20210910141221.fuimjijydw57vxjz@revolver>
References: <20210909145945.12192-1-david@redhat.com>
 <20210909145945.12192-7-david@redhat.com>
 <82d683ec361245e1879b3f14492cdd5c41957e52.camel@linux.ibm.com>
 <d9ec2387-2645-796e-af47-26f22516f7fa@redhat.com>
In-Reply-To: <d9ec2387-2645-796e-af47-26f22516f7fa@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b25e6214-2186-4fe7-7dad-08d9746505f8
x-ms-traffictypediagnostic: DM6PR10MB3337:
x-microsoft-antispam-prvs: <DM6PR10MB333765DDDEE34716282A9D7CFDD69@DM6PR10MB3337.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l1ORGx/dkMQQcQQBccjzx7b/9wauhLa/U+S2jXbA5f2VIyiiZyJJHkYNWCJLAeHqNqh/IbJb4wGLQQsQu/03fcLWshnd/V5I46SFnTICm8/WATS66ywwadQ79HXPdn0ynpWE1USsKw9UJBrUBWZR5r26r8DJiS85bHE9Tjku6H32GBV9yIK/SHhDmYsItLiTuvN3qBZWOx9Eq5iJo55UC7gDzA3jV9rlsQcYygcQmPQAoYQphU//MiISedn8ZyMBDEzDVC3DEei+D24u7DUSt0iuR/fN3LFYZbJWX1pb63sTC+4/GTf9GsaP8ap3PXGYEC/goWjkEqHacwAMHWSvFCsOUoygoXCqAw3XeL55f2eCqscKhqfwc48eHdUflp6vcV3S4CwP/xLkUOfy+U28HhP9qRYOuO8VZL7WJA87CHK9hfLxxEKHhRjfoprBz74bsjOCVH2j7U0eRmcLXCRC+pj/xNR9a7h7NyN2L6/Ef/55DnfKgS9S9jz+o6KBcHNx5OUbER2gHzDhE2BZ63iUfgVqPYpb3SZzHX4l49qgZLO9xSey9xDqjs0DyvCICvmM+13l941I8gL2APAD4Mxjv2rSrJ6f+GIdPstiYeZr6y1yq8cbcYDa9FS3PoZ8mEAhwBjpsXe6+pUltMG7dS8Yzu/HCkP1sBMAqox9bhdGnT0/AY6rvm/KficrQ9YgudYkMgPYGktuXTzuKQl2K4PGiQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4380.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(346002)(396003)(136003)(376002)(39860400002)(1076003)(6512007)(4326008)(6916009)(8936002)(38070700005)(122000001)(86362001)(6486002)(8676002)(9686003)(91956017)(76116006)(478600001)(186003)(83380400001)(71200400001)(6506007)(66476007)(66556008)(64756008)(66446008)(66946007)(316002)(2906002)(53546011)(54906003)(33716001)(5660300002)(44832011)(38100700002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cyVzeeby8izmfSTGAfw29gGCyJ/ZDRIXz8a0Y4Nr8R7mpIkE9+b42nELCBjv?=
 =?us-ascii?Q?jL8d6OS4/QhETj3ykW4Ud3i19CVLS1v9LfvSm6bANS3RPK+SevLWrccDCeCB?=
 =?us-ascii?Q?B97Ov4k7C+i0IhG3U7wWWPV/C9Nhc3xaKh77oW3Jffek0BaMs2/6/4jNzgg4?=
 =?us-ascii?Q?siQs+c52GGuWueNtytsWIvJiFWnYY0fb36hNWsfpxXvsuiCuqEX5/DfTL4PP?=
 =?us-ascii?Q?hIN6uf+yC1oM494ACLuWGavsgtsRmlK+dLVC/n/Btn5c2f3MWRBi2QFfO6LO?=
 =?us-ascii?Q?wopc5OmZ0lYnVeh01+n1bd9+o3hw18NKq76Zi6u8Lw5HKlDEMXFAzErA+KoD?=
 =?us-ascii?Q?d//e4Wypib8ktU405Q8Zyo9FhC90UFVZRSwaMAJ5IdhbCzocehe5aqUjvS7p?=
 =?us-ascii?Q?B7vX3iP5vAdSSgln1m7uiwOFH+Jb/bWOfnRKWJfzCRl++IE69L8moz6CwJP9?=
 =?us-ascii?Q?bwxAynH440zqdHHXK2xa/r3V+dJ4nB+t92m6hHJuC2kZtx2l/tOnDx4Ud1CI?=
 =?us-ascii?Q?HrSqKZlgir5z6GoNgw4Yy1IzcbVlUERdz/epM4XerwnQxyWzGM/Df2al2Wpt?=
 =?us-ascii?Q?Ipr16D3Z/UGveBNEzkma3PUW0Ux7IEyaI5nOOkAtF/Jc9qN9LuwkxfMGw+Nj?=
 =?us-ascii?Q?PcaYvI+p7Og4UxB1Wkf84QFpshcBIhZrw9aiqfpVgGGaIezZUnPrhM7YAtNr?=
 =?us-ascii?Q?XwkjtdWMK6Et4Z6oxga0QMK81S1SHDlfNZjHfKMffNenZySmuecWpVlfHbZT?=
 =?us-ascii?Q?vO2+CB3XxP5pQiOCY2ZKdqYs0bArq3G2en/pl0z6EGY9ltES0c4yrz0JaRqc?=
 =?us-ascii?Q?jfkCMtYxdLawRbRNbXpATft12EsQ44hq3OtPyy+r7ydgwE3RGDh/hZaOuq2S?=
 =?us-ascii?Q?uwRSLCB0FM75ROyKqaOnhWQmVNXM8zzBO9nMoNd53Go1J4oDOgPvZBkqqAh0?=
 =?us-ascii?Q?+3xQpg79P1UeZbTn3avnPWEE7RsMCVFobs2ckX8QMeiAaJN7OjyQRNMYeKOJ?=
 =?us-ascii?Q?PQNFBsL6KJrglkVAh/vOHErZveTSE1OCJcb464zu59ilmNjULnfC+6X/KmQV?=
 =?us-ascii?Q?Gr/MzmBwnscHTW+wiKEDJvy/ctytxRVkbX6mynMpYp4s08DlqcL7dJTwsjCP?=
 =?us-ascii?Q?UQGwWMEzIn27itV4OMBMK3ORM28IZzpGGi7bBT0bUrx6ZM/9ldvMSZ3vX7JB?=
 =?us-ascii?Q?AqsK5Kx1kC5s6SiVKtindR0n4tpClhRo/8BSaPzinTYzrGZJs3t/LEjbaxnP?=
 =?us-ascii?Q?Hf6M9lJecs3VgZn1BE2ajyB/VynvDsA+DX+jNr+HVXeFzeCS1/Fkfmcs6wFT?=
 =?us-ascii?Q?F6+uRPo2KZOV/wQvcvqeWGaH?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3FA59300422AFC4CB78E15D43825E10E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4380.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b25e6214-2186-4fe7-7dad-08d9746505f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2021 14:12:28.8852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rTm8wxXp7fqGK15lJumWYjmG91UKbZggIswyotdInbL1VjfY+UqVOAqqFUlKHjVYqD3YJac4XBLy8CkCnUZ4uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3337
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10102 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0 mlxscore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109100081
X-Proofpoint-ORIG-GUID: 5uq_wtdkdpaWfEvhMtQWEyOzhz32c-o6
X-Proofpoint-GUID: 5uq_wtdkdpaWfEvhMtQWEyOzhz32c-o6
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* David Hildenbrand <david@redhat.com> [210910 05:23]:
> On 10.09.21 10:22, Niklas Schnelle wrote:
> > On Thu, 2021-09-09 at 16:59 +0200, David Hildenbrand wrote:
> > > We should not walk/touch page tables outside of VMA boundaries when
> > > holding only the mmap sem in read mode. Evil user space can modify th=
e
> > > VMA layout just before this function runs and e.g., trigger races wit=
h
> > > page table removal code since commit dd2283f2605e ("mm: mmap: zap pag=
es
> > > with read mmap_sem in munmap").
> > >=20
> > > find_vma() does not check if the address is >=3D the VMA start addres=
s;
> > > use vma_lookup() instead.
> > >=20
> > > Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munma=
p")
> > > Signed-off-by: David Hildenbrand <david@redhat.com>
> > > ---
> > >   arch/s390/pci/pci_mmio.c | 4 ++--
> > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
> > > index ae683aa623ac..c5b35ea129cf 100644
> > > --- a/arch/s390/pci/pci_mmio.c
> > > +++ b/arch/s390/pci/pci_mmio.c
> > > @@ -159,7 +159,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned lon=
g, mmio_addr,
> > >   	mmap_read_lock(current->mm);
> > >   	ret =3D -EINVAL;
> > > -	vma =3D find_vma(current->mm, mmio_addr);
> > > +	vma =3D vma_lookup(current->mm, mmio_addr);
> > >   	if (!vma)
> > >   		goto out_unlock_mmap;
> > >   	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> > > @@ -298,7 +298,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long=
, mmio_addr,
> > >   	mmap_read_lock(current->mm);
> > >   	ret =3D -EINVAL;
> > > -	vma =3D find_vma(current->mm, mmio_addr);
> > > +	vma =3D vma_lookup(current->mm, mmio_addr);
> > >   	if (!vma)
> > >   		goto out_unlock_mmap;
> > >   	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> >=20
> > Oh wow great find thanks! If I may say so these are not great function
> > names. Looking at the code vma_lookup() is inded find_vma() plus the
> > check that the looked up address is indeed inside the vma.
> >=20
>=20
> IIRC, vma_lookup() was introduced fairly recently. Before that, this
> additional check was open coded (and still are in some instances). It's
> confusing, I agree.

This confusion is why I introduced vma_lookup().  My hope is to reduce
the users of find_vma() to only those that actually need the added
functionality, which are mostly in the mm code.

>=20
> > I think this is pretty independent of the rest of the patches, so do
> > you want me to apply this patch independently or do you want to wait
> > for the others?
>=20
> Sure, please go ahead and apply independently. It'd be great if you could
> give it a quick sanity test, although I don't expect surprises --
> unfortunately, the environment I have easily at hand is not very well sui=
ted
> (#cpu, #mem, #disk ...) for anything that exceeds basic compile tests (an=
d
> even cross-compiling is significantly faster ...).
>=20
> >=20
> > In any case:
> >=20
> > Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
> >=20
>=20
> Thanks!
>=20
> --=20
> Thanks,
>=20
> David / dhildenb
>=20
>=20


Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>=
