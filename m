Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9D1406DC9
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 16:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbhIJOxd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 10:53:33 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:13852 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229749AbhIJOxc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Sep 2021 10:53:32 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18AE0B2G002800;
        Fri, 10 Sep 2021 14:52:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=0VpG3SLNax/n3NPbg+SzpfYBFxfdbKemzhOBC//RYj4=;
 b=U1upGlPSXbg293U9FP/WfZ9z/120LR7qJ4PExegD3ptINVk7RYtRbod+1boqN0ncPYWc
 O2Mzi8ahvmsFWi3C7+c+Ded9W5IyeDjxT74F72YtX5AlEO5qFF/O5NP44hApMkgKGoZZ
 OptWU4SWqsfDhnWSkoiVyCZnsk56/GmqJ0zu3G2PJzHmc08YoZZGzMZnl9ptTGiQsTdO
 RYGrBMn3I9gWFwqgVHr6+DYLx0J+4rI8OslO11VNi0fbJmUEcz/uzVINSReyWAGo42ZY
 USKvkXAFcwBMJkNr/ma+IyMLo7QQ2IeG+ZeW8Id4Jkt9/wrgCDDfTapWMvOJn+mW7aD1 1A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=0VpG3SLNax/n3NPbg+SzpfYBFxfdbKemzhOBC//RYj4=;
 b=sARAArrCDMTTXbrsiul/DXJggfHRw+nE0f1zumWxZs4I8WvE0Ow7yD9t4hoW/vH0LoUG
 DqT0npcUqJvJCfcC7n+8J/UG6fjTSPHTJYNUKkiJzpHMkidhK7tkayo65sZLYDQsrwpb
 Acr6Xmu8KXu7cd4lzvwDbCV2hH8Jtnjxac9Vs+yyTgmqQwk4KuDmuETo5Fw5YX5+VFBl
 k3Q3L8IB23XTr3a4la9zvB3FTv3J91oPjWLEQG+2gK9squ9hvS6P2VfGF24IRhU8tyro
 ThRmwzSttaqpmOFGW4ZyeLkLu7c257KnT0LMR78HVb9fusZcLT6zCWhJutSK0mN4ZYvs tQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aytx4t4xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 14:52:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18AEoJ2v063647;
        Fri, 10 Sep 2021 14:52:14 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by aserp3030.oracle.com with ESMTP id 3aytgep2bb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 14:52:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DbyZiU7wOept0zIB0QWr8Aq810Lv4bfK/fywn5fGTz7kaX6YNtWknmxg7M531Pj81uL/2tLkdBfSTimB0zdoSCE4ssb4hXFm+Ru/FM+uKtdhFEh5wQiyvSe2BL4vIhGMAZfziehn9IS1e/gyySidI5eac2dXFoMyKEGMG0xAQPh+ATxvWGcoxnfe6v76UhLydfDnFYtQs4Zqq6CWb2cAWsCkf3Y4wrVW/cGVgtMLI6gV16JQCtudbAmvjUStLlUggDeOGpdfe4IEUdNsaSelkZeTDy7tTOOf7Jj/g8AS53dT+mVgvZejahSmwqPxniQUO2rTp8u0AWdWCKwlslOeMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=0VpG3SLNax/n3NPbg+SzpfYBFxfdbKemzhOBC//RYj4=;
 b=lag+6PYb9OEClGdlhlVwmgm7nJYgIYNEM+5ihHs6tczxzCiT8RIOwkKv8CYpMxqgsHkx3S+M/c6T81blIY69ute9u60C9vH2WIV6Wo5j3uuEycFM/28cpWqDDX3geLZKztM5ccknqPnXYncwzjxUvM0o3HSmmO6cjAe+y7rCckM0fqSu8Gwj+1rMWNBZUB6RFqIQ+277Y2Bejcbb8qi3o2FryIkhHq1OQ4x+pb477Rck5igI2CjutqkS76W7fQaK8MIykwDB5oAifC6s0I7yjb+6iC99MW1G7lexhBQMP57fbhCR+m0dIFno5/CKXFlj0djptCga8q19PW86XZQ07w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0VpG3SLNax/n3NPbg+SzpfYBFxfdbKemzhOBC//RYj4=;
 b=pmXWYFjARjwc6fe+tCqD/dpc9p4rNjDxl+C6qIJsyYzvNlpce/SiL59RiVnKAG5cWcPrycdFbKtHwb2RFSiV8etnqVBb9EYmz2iNO2uQd3lPYXsWuYf5VcSsdcfunfiDcDa3x67eFByIY5MVfUKFoxKmcssi6OBxhpp5I1+v4gY=
Received: from DM6PR10MB4380.namprd10.prod.outlook.com (2603:10b6:5:223::19)
 by DS7PR10MB5005.namprd10.prod.outlook.com (2603:10b6:5:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Fri, 10 Sep
 2021 14:52:13 +0000
Received: from DM6PR10MB4380.namprd10.prod.outlook.com
 ([fe80::f4b1:d890:7745:30a3]) by DM6PR10MB4380.namprd10.prod.outlook.com
 ([fe80::f4b1:d890:7745:30a3%5]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 14:52:12 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
CC:     David Hildenbrand <david@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH RFC 6/9] s390/pci_mmio: fully validate the VMA before
 calling follow_pte()
Thread-Topic: [PATCH RFC 6/9] s390/pci_mmio: fully validate the VMA before
 calling follow_pte()
Thread-Index: AQHXpYt94rWRlMpIgEO//XQ8blRXe6uc7v8AgAARCACAAFCfgIAABVAAgAAFyoA=
Date:   Fri, 10 Sep 2021 14:52:12 +0000
Message-ID: <20210910145205.yihg27ojj6pnaib4@revolver>
References: <20210909145945.12192-1-david@redhat.com>
 <20210909145945.12192-7-david@redhat.com>
 <82d683ec361245e1879b3f14492cdd5c41957e52.camel@linux.ibm.com>
 <d9ec2387-2645-796e-af47-26f22516f7fa@redhat.com>
 <20210910141221.fuimjijydw57vxjz@revolver>
 <209614b6553374cef5fd306d4235a98472fc5e4d.camel@linux.ibm.com>
In-Reply-To: <209614b6553374cef5fd306d4235a98472fc5e4d.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48cebcb1-13ff-4014-77e1-08d9746a92e2
x-ms-traffictypediagnostic: DS7PR10MB5005:
x-microsoft-antispam-prvs: <DS7PR10MB500525EEC3F5BE9F71783E6CFDD69@DS7PR10MB5005.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WDc5gvGNxoaooSR10mlMAfg6tHTEPk2BOcPSBgL0DIDQsBzp34NDvJC4LRtxgLNPtdiTyAk3aCKyJCuTehufFriUR6BI8JmcFVFQtqVNDO6PxOPFGN09xnuLlpox/K+PQ7dXmvdlWlnXU/5hjNhHw1LbrY8FvYUvA8OQWW5iWpOzCUPtM78hsM/MnnPcVY2cCEYG4+HQd5OtxTMWmVWFRJq+CsgxJVNYXHAdMUYTWiA3EWusYDntivRe4tu0r7TMOjcLcgJC3Hm1WI4D8lqPOL5bd2gCf5BS6UmGLW1LRYpFqCER+SYmfWubei616Soj7lmPVTfzbw/QpHHea5k8z33EjNvJQ8C3+1TI5MdCSQi29BewU2kB1SyKCSSr4hiiKmHDyHjfriG5J/yPkZCnDDYRYcpNHPDxiPknV4u9ZNwwbFbeMTyt56NtZkl9wDuH/wFe9nBD8f6wWS0uyyb67jPMdicBAHC6USOE23HY7eIE9RfxnNk5VjB2/ilpw97agC33OvDWydfSrRfE3JqEkt2WLrrKqmJ76UuX70KbVakIgHwDrkHWcRAUX+cD9v7wq/S1q67mDriCJKQkux+gwyKpmI+Muuu42S6Rb9HrxBGaetnI7pKHMn9IFyUwuQLBukwTGM+bNK/oLkupKF7rj6W0ko8GAqxJHrE1APK4jgqWryPCBOAzGJWYKtVQYRY66B26MnzIqBsve/s3xV+KEQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4380.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(396003)(136003)(376002)(346002)(39860400002)(366004)(1076003)(6512007)(4326008)(38100700002)(6916009)(86362001)(122000001)(8936002)(38070700005)(8676002)(9686003)(6486002)(6506007)(478600001)(91956017)(76116006)(83380400001)(64756008)(66476007)(66446008)(66556008)(66946007)(54906003)(53546011)(33716001)(5660300002)(2906002)(316002)(44832011)(186003)(71200400001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JhrOqSTRsyY8aq1PJQ3lAqC0aYbk0kMcl28fYeyLSrh3QzAMwT6aiiQcanf1?=
 =?us-ascii?Q?3Meh02onpmxYzWnh1jSRdMoHqW5MnW9agm4tRgISKOWmzEL49cpMRRIedB0q?=
 =?us-ascii?Q?qOPa+BRQIl1XoGwsK/n/JXUe2A0vTwnPrn+bqmjJqG9C7vyvNkZbyMctQznv?=
 =?us-ascii?Q?7OWNnvs8PSUxwoIRKjiQpKU5PlwS/B/Oo3qgZKsDy7xmmXunpXmodJjmo2w0?=
 =?us-ascii?Q?guHChd1lnXMhODZEDmfdBJWEwjZqP9X6oTZxiU89n677Xo7jtzREFSH6xhft?=
 =?us-ascii?Q?8HRNZ+p2lk1G58JzMQd0oCBfYI0n5cHf0bhwcTFA5C+DrbN5YZpTMQxp+rL4?=
 =?us-ascii?Q?12SXEPfxxRrO4vHtEJqQFYV3CJFMfCK5OnDgyF126uJtAIOLvV6/54JBatRC?=
 =?us-ascii?Q?JARpLf/k33nfjhUr7qkO+pOqENel1609LUT4sD3FDN0qF6LJ7tbvV22aPR5+?=
 =?us-ascii?Q?miYrBBqUu5RZ+YFNI3i7OKhw0C0+wIGzZs/gtNquZggK/jN/m2fY8oPZ7TnP?=
 =?us-ascii?Q?GLZLkugC7fkujc21Vg0A4PfMciv9HQE4QRdxEFOJIlgjF1RIuejeEQKykRXN?=
 =?us-ascii?Q?eBhb7B1ivp0VFrCjluSDZq3H71NrA6XrQZIkSANDFzDY8apLTJ4kWoUsaOnR?=
 =?us-ascii?Q?HIxNFSkDxIl+pGqWARrHyq0IPx2zqrgevESqEKOut0kCBK/3XfChqLryNIs6?=
 =?us-ascii?Q?zeBosU1YIlFhNUDWH/ZeUQ9NdN8Gg9VA0d6mAWeu1PTm+uzfA7nM8Vy9rTb7?=
 =?us-ascii?Q?xzVlg+R4jzvbLZv4V+rEaTFAFzxi1mCxX5hYNIXxx7m1VApEmtyo7g+NzLoX?=
 =?us-ascii?Q?3mqAph4ESIwoPqnk39eXp3JK1MHSGztbt4z+nH1AF5bMT1LKgfjoTKpcdknx?=
 =?us-ascii?Q?+hHr2eQ/q3s7g7CvKKTBf6Z8YqNCF+WP8z1cVNpFO8103uEyB2o+VD9Olaxa?=
 =?us-ascii?Q?Tqy52NDVAUBGIeD/0EsyCr5K+0bZdKsU88sGGOcBtWj9oavobLsaKVtBFB7g?=
 =?us-ascii?Q?wwm7y1I15DBTVijCv+stXa8vTaVl9Fmu3yASZzMPC6gkqMr2VxSUoDuIpl7T?=
 =?us-ascii?Q?O+jLjTMRLiiavIiJjhGgRALs4TiTFDZIRdoy+JZb7gX9CesCHqaq91NNGN+3?=
 =?us-ascii?Q?6g4H+Z8GkQD9je6aX7BfbHlmPsYTX0OpBbUw0HybeBlCIXfTQi+6gw3i0rc2?=
 =?us-ascii?Q?pF2WvCZbwt/IStQndcqtDv+f10OSseoervvOhTfW+F6M5cd3X3Jt5gy2Qr4U?=
 =?us-ascii?Q?2SevLh0zK/EoRxfr7cBoC4OGgI3P/A/flyfNxMrslHXYbHxr/wvqBNaYAoNC?=
 =?us-ascii?Q?c1Pk/2j22ADy1Nv9VKYFEmNu?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FCB6EC1C1EEBFA46B6C09192E51C219B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4380.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48cebcb1-13ff-4014-77e1-08d9746a92e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2021 14:52:12.8500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nSobY59EbjN0IE3iEwUPDtwj9B8mwgx4qa7Md4/scI4rQB/kR5+ZzVgeX5l9PApfy+X+R7fVHKZVxEEHiMJ8HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5005
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10102 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109100085
X-Proofpoint-ORIG-GUID: cGRQAmZm_hka4_S_ZP3LOTIofy2eOrJz
X-Proofpoint-GUID: cGRQAmZm_hka4_S_ZP3LOTIofy2eOrJz
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Niklas Schnelle <schnelle@linux.ibm.com> [210910 10:31]:
> On Fri, 2021-09-10 at 14:12 +0000, Liam Howlett wrote:
> > * David Hildenbrand <david@redhat.com> [210910 05:23]:
> > > On 10.09.21 10:22, Niklas Schnelle wrote:
> > > > On Thu, 2021-09-09 at 16:59 +0200, David Hildenbrand wrote:
> > > > > We should not walk/touch page tables outside of VMA boundaries wh=
en
> > > > > holding only the mmap sem in read mode. Evil user space can modif=
y the
> > > > > VMA layout just before this function runs and e.g., trigger races=
 with
> > > > > page table removal code since commit dd2283f2605e ("mm: mmap: zap=
 pages
> > > > > with read mmap_sem in munmap").
> > > > >=20
> > > > > find_vma() does not check if the address is >=3D the VMA start ad=
dress;
> > > > > use vma_lookup() instead.
> > > > >=20
> > > > > Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in m=
unmap")
> > > > > Signed-off-by: David Hildenbrand <david@redhat.com>
> > > > > ---
> > > > >   arch/s390/pci/pci_mmio.c | 4 ++--
> > > > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > > > >=20
> > > > > diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
> > > > > index ae683aa623ac..c5b35ea129cf 100644
> > > > > --- a/arch/s390/pci/pci_mmio.c
> > > > > +++ b/arch/s390/pci/pci_mmio.c
> > > > > @@ -159,7 +159,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned=
 long, mmio_addr,
> > > > >   	mmap_read_lock(current->mm);
> > > > >   	ret =3D -EINVAL;
> > > > > -	vma =3D find_vma(current->mm, mmio_addr);
> > > > > +	vma =3D vma_lookup(current->mm, mmio_addr);
> > > > >   	if (!vma)
> > > > >   		goto out_unlock_mmap;
> > > > >   	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> > > > > @@ -298,7 +298,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned =
long, mmio_addr,
> > > > >   	mmap_read_lock(current->mm);
> > > > >   	ret =3D -EINVAL;
> > > > > -	vma =3D find_vma(current->mm, mmio_addr);
> > > > > +	vma =3D vma_lookup(current->mm, mmio_addr);
> > > > >   	if (!vma)
> > > > >   		goto out_unlock_mmap;
> > > > >   	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> > > >=20
> > > > Oh wow great find thanks! If I may say so these are not great funct=
ion
> > > > names. Looking at the code vma_lookup() is inded find_vma() plus th=
e
> > > > check that the looked up address is indeed inside the vma.
> > > >=20
> > >=20
> > > IIRC, vma_lookup() was introduced fairly recently. Before that, this
> > > additional check was open coded (and still are in some instances). It=
's
> > > confusing, I agree.
> >=20
> > This confusion is why I introduced vma_lookup().  My hope is to reduce
> > the users of find_vma() to only those that actually need the added
> > functionality, which are mostly in the mm code.
>=20
> Ah I see, soo the confusingly similar names are in hope of one day
> making find_vma() only visible or at least used in the mm code. That
> does make more sense then. Thanks for the explanation! Maybe this would
> be a good candidate for a treewide change/coccinelle script? Then again
> I guess sometimes one really wants find_vma() and it's hard to tell
> apart.
>=20

find_vma() does not describe what the code actually does, so I think it
is a good candidate for a tree wide change.  I'm not sure it would be
popular though.  I couldn't come up with a name that would be worth the
efforts.  If the name does change, then it should also change
find_vma_intersection() as well, nommu code also has a find_vma_exact().
Given the unraveling of a rename, I thought it'd be best to try and
clean up the current code and make it less error-prone with a new mm
API.
